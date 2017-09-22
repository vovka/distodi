class SendServiceCalendarEventsWorker
  include Sidekiq::Worker

  def perform(service_id)
    service = Service.unscoped.find(service_id)
    calendar_events_view_object = calendar_events_view_object(service)
    [
      calendar_events_view_object.performed_service,
      *calendar_events_view_object.future_reminders
    ].each do |icalendar_event|
      UserMailer.service_reminder(service, icalendar_event).deliver_now
    end
  end

  private

  def calendar_events_view_object(service)
    @calendar_events_view_object ||= ServiceCalendarEventsViewObject.new(service)
  end
end
