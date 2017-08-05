module OauthableModel
  extend ActiveSupport::Concern

  included do
    devise :omniauthable, omniauth_providers: [:google_oauth2, :facebook, :twitter, :linkedin]
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
      uid_column = :"#{auth.provider.underscore}_uid"
      profile = Profile.where(uid_column => auth.uid).first
      if profile.present?
        if profile.user.present?
          profile.user
        else
          profile.create_user email: auth.info.email,
                              password: Devise.friendly_token[0, 20],
                              full_name: auth.info.name,
                              picture: auth.info.image
        end
      else
        if auth.info.email.present?
          user = where(email: auth.info.email).first
          if user.present?
            if user.profile.present?
              user.profile.update_attributes uid_column => auth.uid
            else
              user.create_profile uid_column => auth.uid
            end
            user
          else
            create email: auth.info.email,
                   password: Devise.friendly_token[0, 20],
                   full_name: auth.info.name,
                   picture: auth.info.image,
                   profile_attributes: { uid_column => auth.uid }
          end
        else
          user = new password: Devise.friendly_token[0, 20],
                     full_name: auth.info.name,
                     picture: auth.info.image,
                     profile_attributes: { uid_column => auth.uid }
          user.save(validate: false)
          user
        end
      end
    end
  end
end
