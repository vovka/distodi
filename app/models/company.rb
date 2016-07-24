class Company < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  URL_REGEXP = /\A(https?:\/\/)?(www\.)?[-a-zA-Z0-9._]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.,~#?!&\/=]*)\z/


  validates_presence_of :first_name, :last_name, :country, :city, :street
  validates :phone, presence: true, length: {in: 6..20  }
  validates :postal_code, presence: true, length: {is: 5}
  validates :website, allow_blank: true, format: {with: self::URL_REGEXP}
end
