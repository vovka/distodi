class Service < ActiveRecord::Base
  has_many :service_fields
  has_many :service_kinds, through: :service_fields
  has_many :service_action_kinds
  has_many :action_kinds, through: :service_action_kinds
  belongs_to :item
  belongs_to :company

  mount_uploader :picture, PictureUploader

  scope :user_services, ->(user_id) { joins(item: :user).where("users.id = ?", user_id) }
  scope :unconfirmed, -> { where("company_id IS NOT NULL AND confirmed IS NULL") }
end
