class Item < ActiveRecord::Base
  has_many :characteristics
  has_many :attribute_kinds, through: :characteristics
  has_many :services
  belongs_to :category
  belongs_to :user
  belongs_to :transferring_to, class_name: "User",
                               foreign_key: :transferring_to_id

  include IdCodeable

  mount_uploader :picture, PictureUploader

  scope :unconfirmed_services, -> { joins(:services).where("services.company_id IS NOT NULL AND services.confirmed IS NULL") }

  after_create :ensure_token

  validate :valid_user_params

  private

  def valid_user_params
    unless self.user.phone
      errors.add(self.user.first_name, "please, set all fields at profile edit page.")

    end
  end

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

# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null, primary key
#  title              :string
#  category_id        :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#  picture            :string
#  token              :string
#  id_code            :string
#  transferring_to_id :integer
#
# Indexes
#
#  index_items_on_category_id  (category_id)
#
