class ReminderWorker
  include Sidekiq::Worker

  def perform(service_id)
    service = Service.where(id: service_id).first
    if service.present?
      ReminderMailer.remind_about_service(service).deliver
    end
  end
end
