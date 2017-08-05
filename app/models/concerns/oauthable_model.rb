module OauthableModel
  extend ActiveSupport::Concern

  included do
    devise :omniauthable, omniauth_providers: [:google_oauth2, :facebook]
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name=(name)
    name = name.split(" ")
    self.first_name = name.first
    self.last_name = name.last
  end

  class_methods do
    def from_omniauth(auth)
      where(email: auth.info.email).first_or_create do |resource|
        resource.email = auth.info.email
        resource.password = Devise.friendly_token[0,20]
        resource.full_name = auth.info.name
        resource.picture = auth.info.image
      end
    end
  end
end
