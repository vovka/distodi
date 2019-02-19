class Item < ActiveRecord::Base
  has_many :characteristics
  has_many :attribute_kinds, through: :characteristics
  has_many :action_kinds, through: :category
  has_many :services, dependent: :destroy
  belongs_to :category
  belongs_to :user, polymorphic: true
  belongs_to :transferring_to, class_name: "User",
                               foreign_key: :transferring_to_id
  has_one :blockchain_transaction_datum, inverse_of: :service, dependent: :destroy

  validates :title, uniqueness: { scope: [:user_id] }, presence: true
  validates :picture, presence: true
  validates :comment, length: { maximum: 2000 }

  accepts_nested_attributes_for :characteristics

  include IdCodeable

  mount_uploader :picture, ItemUploader
  mount_uploader :picture2, ItemUploader
  mount_uploader :picture3, ItemUploader
  mount_uploader :picture4, ItemUploader
  mount_uploader :picture5, ItemUploader

  scope :without_demo, -> { where demo: false }
  scope :with_demo, -> { unscope(where: :demo) }
  scope :unconfirmed_services, -> { joins(:services).where("services.company_id IS NOT NULL AND services.confirmed IS NULL") }

  default_scope { without_demo }

  after_create :ensure_token

  def self.to_csv(item)
    data = item.characteristics.includes(:attribute_kind).map do |c|
      [c.attribute_kind.title, c.value]
    end
    data << [""]

    CSV.generate { |csv| data.each { |line| csv << line } } +
    Service.to_csv(item.services)
  end

  def characteristics_ordered
    characteristics.joins(:attribute_kind).order("attribute_kinds.position")
  end

  def to_blockchain_hash
    {
      id: id,
      user_id: user_id,
      user_type: user_type,
      transferring_to_id: transferring_to_id,
      category:   {
        id: category.id,
      }
    }
  end

  private

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
#  demo               :boolean
#  picture2           :string
#  picture3           :string
#  picture4           :string
#  picture5           :string
#  comment            :string(2000)
#  user_type          :string
#
# Indexes
#
#  index_items_on_category_id  (category_id)
#
