FactoryGirl.define do
  factory :item do
    title "car"

    trait :with_user do
      user
    end
  end
end

# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  title       :string
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  picture     :string
#  token       :string
#
# Indexes
#
#  index_items_on_category_id  (category_id)
#
