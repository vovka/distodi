class Company < ActiveRecord::Base
  # Include default devise modules. Others available are:
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include OauthableModel

  URL_REGEXP = /\A(https?:\/\/)?(www\.)?[-a-zA-Z0-9._]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.,~#?!&\/=]*)\z/

  has_many :services
  has_many :items, through: :services
  has_many :assigned_services, foreign_key: :approver_id,
                               class_name: "Service",
                               as: :approver
  has_many :service_kinds

  validates_presence_of :first_name
  validates :phone, phone: true, allow_blank: true
  validates :postal_code, presence: true, length: { is: 5 }, allow_blank: true
  validates :website, format: {with: self::URL_REGEXP}, allow_blank: true

  mount_uploader :picture, PictureUploader

  default_scope { where demo: false }
  scope :demo, -> { unscoped.where demo: true }
  scope :user_companies, lambda { |user_id|
    joins(services: { item: :user }).where(users: { id: user_id })
  }

  def accept_invitation!
    if invited_to_sign_up?
      @accepting_invitation = true
      run_callbacks :invitation_accepted do
        accept_invitation
        confirmed_at = invitation_accepted_at if respond_to?(:confirmed_at)
        self.active = true
        save validate: false
      end.tap { @accepting_invitation = false }
    end
  end

  def map_address
    [city, address].compact.join(", ")
  end
end

# == Schema Information
#
# Table name: companies
#
#  id                     :integer          not null, primary key
#  name                   :string
#  phone                  :string
#  country                :string
#  city                   :string
#  address                :string
#  postal_code            :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  website                :string
#  notice                 :string
#  first_name             :string
#  last_name              :string
#  picture                :string
#  active                 :boolean          default("true")
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default("0")
#  demo                   :boolean
#
# Indexes
#
#  index_companies_on_email                 (email) UNIQUE
#  index_companies_on_invitation_token      (invitation_token) UNIQUE
#  index_companies_on_invitations_count     (invitations_count)
#  index_companies_on_invited_by_id         (invited_by_id)
#  index_companies_on_reset_password_token  (reset_password_token) UNIQUE
#
