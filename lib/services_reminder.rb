class ServicesReminder
  REMINDER_TIMESPAN = 3.days

  attr_reader :mailer
  private :mailer

  def initialize(mailer = CompanyMailer)
    @mailer = mailer
  end

  def call
    services = fetch_services
    emails = fetch_emails services
    deliver emails
  end

  private

  def fetch_services
    Service.where("created_at < '#{REMINDER_TIMESPAN.ago.to_s(:db)}'")
           .where(status: Service::STATUS_PENDING)
  end

  def fetch_emails(services)
    services.map(&:approver).uniq.compact.map(&:email)
  end

  def deliver(emails)
    emails.each do |email|
      mailer.reminder_service_email(email).deliver_now!
    end
  end
end
