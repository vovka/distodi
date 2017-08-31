class UserMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def confirmation_email(user)
    @user = user
    mail to: user.email,
         subject: "Confirmation Email"
  end

  def add_service_email(user)
    @user = user
    mail to: user.email,
         subject: "A service was created"
  end

  def add_service_email_to_company(user)
    @user = user
    mail to: user.email,
         subject: "A service was created"
  end

  def transfer_notification_email(sender, receiver)
    @sender = sender
    @receiver = receiver
    mail to: receiver.email,
         subject: t(".item_was_transferred_to_you.subject")
  end

  def service_reminder(service, icalendar_event)
    @user = service.user
    attachments["event.ics"] = { mime_type: "text/calendar",
                                 content: icalendar_event.to_ical }
    mail to: @user.email,
         subject: t(".service_reminder.subject")
  end
end
