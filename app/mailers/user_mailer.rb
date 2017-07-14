class UserMailer < ApplicationMailer

  def confirmation_email(user)
    @user = user
    mail to: user.email,
         subject: 'Confirmation Email'
  end

  def add_service_email(user)
    @user = user
    mail to: user.email,
         subject: 'Service added Email'
  end

  def add_service_email_to_company(user)
    @user = user
    mail to: user.email,
         subject: 'Service added Email'
  end

  def transfer_notification_email(sender, receiver)
    @sender = sender
    @receiver = receiver
    mail to: receiver.email,
         subject: t(".item_was_transferred_to_you")
  end
end
