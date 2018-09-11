class ServiceDecorator < Draper::Decorator
  DEFAULT_CHECKED_ACTION_TITLE = "Control".freeze
  SHORT_BLOCKCHAIN_HASH_SYMBOLS = 0..5.freeze

  delegate_all
  delegate :blockchain_hash, to: :blockchain_transaction_datum, allow_nil: true

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def permissions(user)
    {
      delete: ServicePolicy.new(user, self).destroy?
    }
  end

  def predefined_reminders
    object.class::PREDEFINED_REMINDERS.keys.map.with_index do |name, i|
      [i, I18n.t("activerecord.models.service.attributes.predefined_reminders.#{name}")]
    end
  end

  def companies_options
    Company.joins(:assigned_services => :item).where(items: { user: user }).where.not(name: [nil, ""]).uniq + [other_company_option]
  end

  def companies_options_edit
    [myself_option] + Company.all
  end

  def myself_option
    Struct.new(:id, :name).new(-1, I18n.t("services.form.myself"))
  end

  def other_company_option
    Struct.new(:id, :name).new(-2, I18n.t("services.form.other"))
  end

  def checked_action?(action_kind)
    action_kind == default_checked_action_kind
  end

  def approver_name
    if service.approver.present?
      service.approver.name
    else
      I18n.t("company.deleted")
    end
  end

  def approver_address
    if service.approver.present?
      service.approver.map_address
    else
      I18n.t("company.deleted")
    end
  end

  def approver_mail
    if service.approver.present?
      service.approver.email
    else
      I18n.t("company.deleted")
    end
  end

  def approver_phone
    if service.approver.present?
      service.approver.phone
    else
      I18n.t("company.deleted")
    end
  end

  def owner
    if service.user.present?
      service.user.full_name
    else
      I18n.t("user.deleted")
    end
  end

  def short_blockchain_hash
    blockchain_hash.try(:[], SHORT_BLOCKCHAIN_HASH_SYMBOLS)
  end

  private

  def default_checked_action_kind
    default_action = available_action_kinds.find { |action_kind| action_kind.title == DEFAULT_CHECKED_ACTION_TITLE }
    default_action.presence || item.category.action_kinds.first
  end
end
