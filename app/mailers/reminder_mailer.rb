class ReminderMailer < ApplicationMailer
  def remind_about_service(service)
    @user = service.user
    @service = service
    mail to: @user.email,
         subject: I18n.t("mailers.reminder.remind_about_service.subject")
  end
end
