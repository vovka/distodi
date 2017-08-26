class Service < ActiveRecord::Base
  STATUSES = [
    STATUS_PENDING = "pending".freeze,
    STATUS_APPROVED = "approved".freeze,
    STATUS_DECLINED = "declined".freeze
  ].freeze
  PREDEFINED_REMINDERS = {
    week: -> { 1.week },
    month: -> { 1.month },
    months_3: -> { 3.months },
    months_6: -> { 6.months },
    year: -> { 1.year },
    years_2: -> { 2.years }
  }.freeze

  attr_accessor :reminders_predefined, :reminder_custom

  mount_uploader :picture, PictureUploader

  has_many :service_fields, dependent: :destroy
  has_many :service_kinds, through: :service_fields
  has_many :service_action_kinds, dependent: :destroy
  has_many :action_kinds, through: :service_action_kinds
  belongs_to :item
  belongs_to :company
  belongs_to :approver, polymorphic: true

  delegate :map_address, to: :company, allow_nil: true
  delegate :category, :user, to: :item, allow_nil: true

  include IdCodeable

  default_scope { where demo: false }
  scope :demo, -> { unscoped.where demo: true }
  scope :pending, -> { where(status: STATUS_PENDING) }
  scope :approved, -> { where(status: STATUS_APPROVED) }
  scope :declined, -> { where(status: STATUS_DECLINED) }
  scope :user_services, ->(user_id) { joins(item: :user).where("users.id = ?", user_id) }
  scope :unconfirmed, -> { where("company_id IS NOT NULL AND confirmed IS NULL") }

  validates :reason, presence: true,
                     length: { maximum: 1023 },
                     if: -> { status == STATUS_DECLINED }

  before_create do |service|
    service.status = STATUS_APPROVED if service.self_approvable?
  end

  after_create :set_reminders
  # after_create { ServiceCalendarMailerWorker.perform_async(id) }
  after_create :send_calendar_events

  def self.to_csv(services)
    data = [ServiceCSVDecorator.humanized_columns] +
           services.map { |service| ServiceCSVDecorator.new service }
    CSV.generate { |csv| data.each { |line| csv << line } }
  end

  def self_approvable?(user = nil)
    approver.nil?
  end

  def approve!(_ = nil)
    update status: STATUS_APPROVED, approver: approver
  end

  def decline!(reason)
    update status: STATUS_DECLINED, reason: reason
  end

  def declined?
    STATUS_DECLINED == status
  end

  def approved?
    STATUS_APPROVED == status
  end

  def approver?(user)
    approver == user
  end

  def requires_action?
    STATUS_PENDING == status
  end

  def describe
    {
      created_at: created_at,
      action_kinds: action_kinds.map(&:title).join(", "),
      service_kinds: service_kinds.map(&:title).join(", ")
    }
  end

  def reminder_dates
    (predefined_durations + [custom_duration]).compact
  end

  def send_calendar_events
    [
      calendar_events_view_object.performed_service,
      *calendar_events_view_object.future_reminders
    ].each do |icalendar_event|
      UserMailer.service_reminder(self, icalendar_event).deliver_now
    end
  end

  private

  def set_reminders
    logger.info $/ * 3
    reminder_dates.each do |duration|
      logger.info "setting reminder for #{duration.from_now}"
      ReminderWorker.perform_in(duration, id)
    end
    logger.info $/ * 3
  end

  def predefined_durations
    PREDEFINED_REMINDERS.values.values_at(*reminders_predefined).map do |object|
      object.call
    end
  end

  def custom_duration
    (reminder_custom.to_time - Time.zone.now).seconds if reminder_custom.present?
  end

  def calendar_events_view_object
    @calendar_events_view_object ||= ServiceCalendarEventsViewObject.new(self)
  end
end

# == Schema Information
#
# Table name: services
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  item_id       :integer
#  next_control  :date
#  picture       :string
#  price         :float
#  company_id    :integer
#  confirmed     :boolean
#  status        :string           default("pending")
#  approver_id   :integer
#  approver_type :string
#  reason        :string(1023)
#  id_code       :string
#  demo          :boolean
#
