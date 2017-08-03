class DemoDataService
  SERVICES_AMOUNT_RANGE = 5..10
  DEFAULT_COUNTRY = "Ukraine"
  DEFAULT_LAST_NAME = "-"
  DEMO_TITLE_PLACEHOLDER = "[DEMO] "

  attr_reader :user
  private     :user

  def initialize(user)
    @user = user
  end

  def perform
    user.country ||= DEFAULT_COUNTRY
    user.last_name ||= DEFAULT_LAST_NAME
    Category.all.each do |category|
      item = Item.demo.create item_attributes_for(category).merge(category: category, user: user)
      services_amount.times do
        item.services.create service_attributes_for(category)
      end
    end
  end

  private

  def item_attributes_for(category)
    category_name = category.name.underscore
    {
      title: DEMO_TITLE_PLACEHOLDER + item_title_for(category_name),
      picture: picture_for(category_name)
    }
  end

  def service_attributes_for(category)
    category_name = category.name.underscore
    {
      next_control: service_next_control_for,
      picture: picture_for(category_name),
      price: service_price_for,
      company: service_company_for,
      status: service_status_for,
      approver: service_approver_for,
      reason: service_reason_for,
      service_kinds: [category.service_kinds.sample],
      action_kinds: [category.action_kinds.sample]
    }
  end

  def services_amount
    SERVICES_AMOUNT_RANGE.to_a.sample
  end

  def item_title_for(category_name)
    "My #{category_name.humanize}"
  end

  def picture_for(category_name)
    File.open(Rails.root.join("app/assets/images/demo_#{category_name}.jpg"))
  end

  def service_next_control_for
    365.days.from_now
  end

  def service_price_for
    Faker::Commerce.price
  end

  def service_company_for
    @service_company = Company.demo.offset(Kernel.rand(Company.demo.count)).first
  end

  def service_status_for
    @service_status = Service::STATUSES.sample
  end

  def service_approver_for
    @service_company if @service_status != Service::STATUS_PENDING
  end

  def service_reason_for
    Faker::Lorem.sentence if @service_status != Service::STATUS_PENDING
  end
end
