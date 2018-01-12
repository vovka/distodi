class Notification < ActiveRecord::Base
  belongs_to :user

  scope :user, ->(user) { where user: user }
  scope :active, -> { where read: false }

  def build_message(event_name, *args)
    case event_name
    when :service_approved
      I18n.t("activerecord.models.notification.build_message.#{event_name}", name: args[0].company.try(:name))
    when :service_rejected
      I18n.t("activerecord.models.notification.build_message.#{event_name}", name: args[0].company.try(:name))
    when :remind_about_service
      I18n.t("activerecord.models.notification.build_message.#{event_name}", service: args[0].item.try(:title))
    end
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
