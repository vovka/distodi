class DemoDataService
  SERVICES_AMOUNT_RANGE = 10..10
  DEFAULT_COUNTRY = "Ukraine"
  DEFAULT_LAST_NAME = "-"
  DEMO_TITLE_PLACEHOLDER = "[DEMO] "

  attr_reader :user
  private     :user

  def initialize(user)
    @user = user
  end

  def perform
    item = nil
    services = []
    with_user_default_fields do
      Category.all.each do |category|
        item = user.items.new item_attributes_for(category)
        item.save(validate: false)
        @service_counter = 0
        services_amount.times do
          service = item.services.new service_attributes_for(category)
          service.save(validate: false)
          services << service
          @service_counter += 1
        end
      end
    end
    [item, services]
  end

  private

  def with_user_default_fields(&block)
    reset_coutry = user.country.blank?
    reset_last_name = user.last_name.blank?

    attributes = {}
    attributes[:country] = DEFAULT_COUNTRY if reset_coutry
    attributes[:last_name] = DEFAULT_LAST_NAME if reset_last_name
    user.update attributes

    yield

    attributes = {}
    attributes[:country] = nil if reset_coutry
    attributes[:last_name] = nil if reset_last_name
    user.update attributes
  end

  def item_attributes_for(category)
    category_name = category.name.parameterize("_")

    attribute_kinds = category.attribute_kinds
    values = attribute_kinds.map do |ak|
      demo_value_for(:item, category_name, ak.title.parameterize("_"))
    end
    characteristics_attributes = attribute_kinds.map.with_index do |ak, i|
      { attribute_kind: ak, value: values[i] } if values[i].present?
    end.compact

    {
      demo: true,
      category: category,
      title: demo_value_for(:item, category_name, :title),
      picture: picture_for(category_name),
      comment: demo_value_for(:item, category_name, :comment),
      characteristics_attributes: characteristics_attributes
    }
  end

  def demo_value_for(*args)
    key = "service_objects.demo_data_service.#{args.join(".")}"
    ary = I18n.t(key, default: "")
    if ary.respond_to? :sample
      ary.sample
    else
      ary.presence
    end
  end

  def service_attributes_for(category)
    category_name = category.name.parameterize("_")
    result = {}
    result[:demo] = true
    result[:next_control] = service_next_control_for
    result[:picture] = picture_for(category_name)
    result[:price] = service_price_for
    result[:status] = service_status_for(category.action_kinds.count)
    result[:action_kinds] = [next_action_kind(category)]
    result[:company] = service_company_for(category_name)
    result[:approver] = service_approver_for
    result[:reason] = service_reason_for(category_name)
    result[:service_kinds] = [category.service_kinds.sample]
    result
  end

  def services_amount
    SERVICES_AMOUNT_RANGE.to_a.sample
  end

  def picture_for(category_name)
    File.open(picture_path(category_name))
  end

  def picture_path(category_name)
    Rails.root.join("app/assets/images/demo_#{category_name}.jpg")
  end

  def service_next_control_for
    365.days.from_now
  end

  def service_price_for
    Faker::Commerce.price
  end

  def service_company_for(category_name)
    current_action_kind = next_action_kind(nil, false)
    company_names = demo_value_for(
      :service,
      category_name,
      current_action_kind.title.parameterize("_"),
      :company_name
    )
    @service_company = Company.demo
                              .where(name: company_names)
                              .order("RANDOM()")
                              .first
  end

  def service_status_for(tick_at = 1)
    @service_status = next_status if ((@service_counter - 1) % tick_at).zero?
    @service_status
  end

  def next_status
    @statuses ||= Service::STATUSES.dup.rotate(-1)
    @statuses.rotate!.first
  end

  def next_action_kind(category, perform = true)
    (@action_kinds ||= category.action_kinds.dup.rotate(-1))
    @action_kinds.rotate! if perform
    @action_kinds.first
  end

  def service_approver_for
    @service_company
  end

  def service_reason_for(category_name)
    if @service_status == Service::STATUS_DECLINED
      demo_value_for(:service, category_name, :decline_reason)
    end
  end
end
