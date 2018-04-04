class ServiceCalendarEventsViewObject
  attr_reader :service
  private     :service

  def initialize(service)
    @service = service
  end

  def performed_service
    build_ical_object(
      service.created_at,
      service.created_at.end_of_day,
      service_description
    )
  end

  def future_reminders
    service.reminder_dates.map do |duration|
      build_ical_object(
        duration.from_now.beginning_of_day,
        duration.from_now.end_of_day,
        "#{I18n.t("view_objects.service_calendar_events.future_reminders.summary_prefix")}: #{service_description}"
      )
    end
  end

  private

  def build_ical_object(start_time, end_time, summary)
    ical = Icalendar::Calendar.new
    ical.event do |e|
      e.dtstart     = Icalendar::Values::Date.new(start_time)
      e.dtend       = Icalendar::Values::Date.new(end_time)
      e.summary     = summary
      # e.description = "Have a long lunch meeting and decide nothing..."
      e.ip_class    = "PRIVATE"
      e.organizer   = Icalendar::Values::CalAddress.new("https://distodi.com")
    end
    # ical.publish
    ical
  end

  def service_description
    "#{service.item.title}: #{service.describe.slice(:action_kinds, :service_kinds).values.join("; ")}"
  end
end
