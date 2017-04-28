FactoryGirl.define do
  factory :characteristic do
  end
end

# == Schema Information
#
# Table name: characteristics
#
#  id                :integer          not null, primary key
#  item_id           :integer
#  attribute_kind_id :integer
#  value             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
