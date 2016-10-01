class Item < ActiveRecord::Base
  has_many :characteristics
  has_many :attribute_kinds, through: :characteristics
  has_many :services
  belongs_to :category
  belongs_to :user


  mount_uploader :picture, PictureUploader

  scope :unconfirmed_services, -> { joins(:services).where("services.company_id IS NOT NULL AND services.confirmed IS NULL") }

  before_create :ensure_token

  def generate_token
    loop do
      token = Devise.friendly_token.downcase
      break token unless self.class.exists?(token: token)
    end
  end

  def ensure_token
    self.update_attribute(:token, generate_token) if self.token.blank?
  end
end
