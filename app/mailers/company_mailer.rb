class CompanyMailer < ApplicationMailer

  def service_confirmed_email(company)
    @company = company
    mail to: company.email,
         subject: 'Service confirmed!'
  end

  def reminder_service_email(email)
    mail to: email,
         subject: 'Service remind!'
  end
end
