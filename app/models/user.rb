class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable

  include OauthableModel

  has_many :items, as: :user, dependent: :destroy
  has_many :transferring_items, class_name: "Item",
                                foreign_key: :transferring_to_id
  has_many :services, through: :items
  has_many :blockchain_transaction_data, through: :services
  has_many :assigned_services, foreign_key: :approver_id,
                               class_name: "Service",
                               as: :approver
  has_many :notifications

  validates :first_name, presence: true
  validates :phone, phone: true, allow_blank: true
  validates :postal_code, zipcode: { country_code_attribute: :country_short }, allow_blank: true

  mount_uploader :picture, AccountUploader

  def country_object
    ISO3166::Country.find_country_by_name country
  end

  def country_short
    country_object.try :alpha2
  end

  def create_notification(event_name, *args)
    notification = notifications.build
    message = notification.build_message(event_name, *args)
    notification.message = message
    notification.save
    notification
  end

  def to_blockchain_hash
    {
      id: id
    }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  phone                  :string
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
#  country                :string
#  city                   :string
#  address                :string
#  postal_code            :string
#  notice                 :string
#  picture                :string
#
# Indexes
#
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
