class Company < ActiveRecord::Base
  include CanStubs::Model

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  URL_REGEXP = /\A(https?:\/\/)?(www\.)?[-a-zA-Z0-9._]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.,~#?!&\/=]*)\z/

  has_many :services
  has_many :assigned_services, foreign_key: :approver_id,
                               class_name: "Service",
                               as: :approver
  has_many :service_kinds

  validates_presence_of :first_name
  validates :phone, presence: true, length: { in: 6..20 }, allow_blank: true
  validates :postal_code, presence: true, length: { is: 5 }, allow_blank: true
  validates :website, format: {with: self::URL_REGEXP}, allow_blank: true

  mount_uploader :picture, PictureUploader

  scope :user_companies, lambda { |user_id|
    joins(services: { item: :user }).where(users: { id: user_id })
  }
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
#  street                 :string
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
#
# Indexes
#
#  index_companies_on_email                 (email) UNIQUE
#  index_companies_on_reset_password_token  (reset_password_token) UNIQUE
#
