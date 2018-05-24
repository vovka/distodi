class CompanyMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def confirmation_email(company)
    @company = company
    mail to: company.email,
         subject: t(".company_confirmation.subject")
  end

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
