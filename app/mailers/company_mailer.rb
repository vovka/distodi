class CompanyMailer < ApplicationMailer

  def service_confirmed_email(company)
    @company = company
    mail to: company.email,
         subject: 'Service confirmed!'
  end
end
