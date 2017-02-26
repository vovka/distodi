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
end
