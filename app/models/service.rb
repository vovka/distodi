class Service < ActiveRecord::Base
  STATUS_PENDING = "pending".freeze
  STATUS_APPROVED = "approved".freeze
  STATUS_DECLINED = "declined".freeze

  mount_uploader :picture, PictureUploader

  has_many :service_fields, dependent: :destroy
  has_many :service_kinds, through: :service_fields
  has_many :service_action_kinds, dependent: :destroy
  has_many :action_kinds, through: :service_action_kinds
  belongs_to :item
  has_one :user, through: :item
  belongs_to :company
  belongs_to :approver, polymorphic: true

  delegate :category, to: :item, allow_nil: true
  delegate :map_address, to: :company, allow_nil: true

  include IdCodeable

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
#
