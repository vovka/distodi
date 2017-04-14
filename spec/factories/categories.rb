FactoryGirl.define do
  factory :category do
    trait :with_service_kinds do
      after :create do |category|
        category.service_kinds = create_list :service_kind, 3
      end
    end

    trait :with_action_kinds do
      after :create do |category|
        category.action_kinds = create_list :action_kind, 3
      end
    end
  end
end

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
