class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :items

  validates_presence_of :first_name, :last_name, :country, :city, :street
  validates :phone, presence: true, length: {in: 6..20  }
  validates :postal_code, presence: true, length: {is: 5}

  mount_uploader :picture, PictureUploader



  # scope :user_services, ->(user_id) { joins(items: :services).where("users.id = ?", user_id) }
end
