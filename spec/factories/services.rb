FactoryGirl.define do
  factory :service do
    price { Faker::Commerce.price }
    action_kinds { build_list :action_kind, 1 }

    transient do
      item_title "A Car"
    end

    after(:build) do |service, evaluator|
      if service.item.blank?
        item = create :item, title: evaluator.item_title#, services: [service]
        service.item = item
      end
    end

    trait :with_action_kinds do
      after(:create) do |service|
        service.action_kinds.create! attributes_for(:action_kind)
      end
    end
  end
end

# == Schema Information
#
# Table name: services
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  item_id       :integer
#  next_control  :date
#  picture       :string
#  price         :float
#  company_id    :integer
#  confirmed     :boolean
#  status        :string           default("pending")
#  approver_id   :integer
#  approver_type :string
#  reason        :string(1023)
#  id_code       :string
#  demo          :boolean
#
