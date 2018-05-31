FactoryGirl.define do
  factory :service_kind do
    title { Faker::Lorem.word }
  end
end

# == Schema Information
#
# Table name: service_kinds
#
#  id         :integer          not null, primary key
#  title      :string
#  with_text  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
