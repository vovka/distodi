class Service < ActiveRecord::Base
  has_many :service_fields, dependent: :destroy
  has_many :service_kinds, through: :service_fields
  has_many :service_action_kinds, dependent: :destroy
  has_many :available_action_kinds, through: :item, source: :action_kinds
  has_many :action_kinds, through: :service_action_kinds
  belongs_to :item, -> { unscope(where: :demo) }
  belongs_to :company
  belongs_to :approver, -> { unscope(where: :demo) }, polymorphic: true
  has_one :blockchain_transaction_datum, inverse_of: :service

  accepts_nested_attributes_for :service_fields

  STATUSES = [
    STATUS_PENDING = "pending".freeze,
    STATUS_APPROVED = "approved".freeze,
    STATUS_DECLINED = "declined".freeze,
    STATUS_PREAPPROVED = "preapproved".freeze
  ].freeze
  PREDEFINED_REMINDERS = {
    week: -> { 1.week },
    month: -> { 1.month },
    months_3: -> { 3.months },
    months_6: -> { 6.months },
    year: -> { 1.year },
    years_2: -> { 2.years }
  }.freeze
  PREDEFINED_ROAD_REASONS = {
    take: "Take goods",
    pick_up: "Pick up the goods",
    passengers: "Passenger transportation",
    home: "Way to home (to the office or home)",
    transit: "Transit (work reason) ",
    service: "Service (repair)"
  }.freeze

  attr_accessor :reminders_predefined, :reminder_custom

  mount_uploader :picture, ItemUploader
  mount_uploader :picture2, ItemUploader
  mount_uploader :picture3, ItemUploader
  mount_uploader :picture4, ItemUploader

  delegate :map_address, to: :company, allow_nil: true
  delegate :category, :user, to: :item, allow_nil: true

  include IdCodeable

  scope :without_demo, -> { where demo: false }
  scope :with_demo, -> { unscope(where: :demo) }
  scope :pending, -> { where(status: STATUS_PENDING) }
  scope :approved, -> { where(status: STATUS_APPROVED) }
  scope :declined, -> { where(status: STATUS_DECLINED) }
  scope :preapproved, -> { where(status: STATUS_PREAPPROVED) }
  scope :user_services, ->(user_id) { joins(item: :user).where("users.id = ?", user_id) }
  scope :unconfirmed, -> { where("company_id IS NOT NULL AND confirmed IS NULL") }

  validates :reason, presence: true,
                     length: { maximum: 1023 },
                     if: -> { status == STATUS_DECLINED }
  validates :comment, length: { maximum: 2000 }
  validates :service_kinds, presence: true, unless: :road?
  validate do |service|
    service.errors.add(:approver, :blank) if service.approver.present? && !service.approver.persisted?
  end

  before_validation { |service| service.service_fields = [] if service.road? }

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
    if approver.respond_to?(:verified) && !approver.verified
      update status: STATUS_PREAPPROVED, approver: approver
    else
      update status: STATUS_APPROVED, approver: approver
    end
    user.create_notification(:service_approved, self)
  end

  def decline!(reason)
    update status: STATUS_DECLINED, reason: reason
    user.create_notification(:service_rejected, self)
  end

  def declined?
    STATUS_DECLINED == status
  end

  def approved?
    STATUS_APPROVED == status
  end

  def pending?
    STATUS_PENDING == status
  end

  def preapproved?
    STATUS_PREAPPROVED == status
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
    unless item.demo?
      SendServiceCalendarEventsWorker.perform_async(id)
    end
  end

  def to_blockchain_hash
    r = {
      id: id,
      created_at: created_at,
      updated_at: updated_at,
      next_control: next_control,
      price: price,
      # currency: currency,
      status: status,
      reason: reason,
      id_code: id_code,
      comment: comment,
      approver_type: approver_type
    }
    r[:approver] = approver.to_blockchain_hash if approver.present?
    r[:item] = item.to_blockchain_hash if item.present?
    r[:action_kind] = action_kinds.first.to_blockchain_hash if action_kinds.any?
    r[:service_field] = service_fields.first.to_blockchain_hash if service_fields.any?
    r
  end

  def road?
    action_kinds.any? && action_kinds.first.road?
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
#  picture2      :string
#  picture3      :string
#  picture4      :string
#  comment       :string(2000)
#  distance      :float
#  fuel          :float
#  customer      :string
#  start_lat     :float
#  start_lng     :float
#  end_lat       :float
#  end_lng       :float
#  road_reasons  :integer          default("{}"), is an Array
#  performed_at  :date
#
