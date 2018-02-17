FactoryGirl.define do
  factory :action_kind do
  end
end

# == Schema Information
#
# Table name: action_kinds
#
#  id           :integer          not null, primary key
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  abbreviation :string
#  position     :integer
#
