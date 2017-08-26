class ServiceCalendarMailerWorker
  include Sidekiq::Worker

  def perform(service_id)
    service = Service.where(id: service_id).first
    service.send_calendar_events if service.present?
  end
end
