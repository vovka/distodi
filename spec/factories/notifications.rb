FactoryGirl.define do
  factory :notification do
    message { Faker::Lorem.sentence }
  end
end

# == Schema Information
#
# Table name: notifications
#
#  id      :integer          not null, primary key
#  message :string
#  read    :boolean          default("false")
#  user_id :integer
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#
