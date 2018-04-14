class ServiceDecorator < Draper::Decorator
  DEFAULT_CHECKED_ACTION_TITLE = "Control".freeze

  delegate_all

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
    Company.all + [other_company_option]
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

  private

  def default_checked_action_kind
    default_action = available_action_kinds.find { |action_kind| action_kind.title == DEFAULT_CHECKED_ACTION_TITLE }
    default_action.presence || item.category.action_kinds.first
  end
end
