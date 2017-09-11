class Notification < ActiveRecord::Base
  belongs_to :user

  scope :user, ->(user) { where user: user }
  scope :active, -> { where read: false }
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
