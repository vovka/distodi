class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :items
  has_many :transferring_items, class_name: "Item",
                                foreign_key: :transferring_to_id
  has_many :services, through: :items
  has_many :assigned_services, foreign_key: :approver_id,
                               class_name: "Service",
                               as: :approver

  validates_presence_of :first_name
  validates :phone, presence: true, length: { in: 6..20 }, allow_blank: true
  validates :postal_code, presence: true, length: { is: 5 }, allow_blank: true

  mount_uploader :picture, PictureUploader

  devise :omniauthable, :omniauth_providers => [:facebook]
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def full_name
    "#{first_name} #{last_name}"
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
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
