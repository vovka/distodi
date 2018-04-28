module OauthableModel
  extend ActiveSupport::Concern

  included do
    has_one :profile
    accepts_nested_attributes_for :profile
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name=(name)
    name = name.split(" ")
    self.first_name = name.first
    self.last_name = name.last
  end

  def after_sign_up_actions!
    UserMailer.confirmation_email(self).deliver_later
    CreateDemoDataWorker.perform_async(self.class, id)
  end

  class_methods do
    def from_omniauth(auth)
      uid_column = :"#{auth.provider.underscore}_uid"
      profile = Profile.where(uid_column => auth.uid).first
      association_name = Profile.reflect_on_all_associations(:belongs_to).find { |r| r.klass == self }.name
      if profile.present?
        resource = profile.send(association_name)
        if resource.nil?
          attributes = { password: Devise.friendly_token[0, 20],
                         full_name: auth.info.name,
                         picture: auth.info.image }
          options = {}
          if auth.info.email.present?
            association_class = Profile.reflect_on_all_associations(:belongs_to).find { |r| r.klass == self }.klass
            resource = association_class.where(email: auth.info.email).first
            if resource.nil?
              attributes.merge! email: auth.info.email
            end
          end
          options.merge! validate: false
          resource ||= profile.send(:"build_#{association_name}", attributes)
          profile.send(:"#{association_name}").save(options)
          resource.after_sign_up_actions!
        end
        resource
      else
        if auth.info.email.present?
          resource = where(email: auth.info.email).first
          if resource.present?
            if resource.profile.present?
              resource.profile.update_attributes uid_column => auth.uid
            else
              resource.create_profile uid_column => auth.uid
            end
            resource
          else
            resource = new email: auth.info.email,
                   password: Devise.friendly_token[0, 20],
                   full_name: auth.info.name,
                   picture: auth.info.image,
                   profile_attributes: { uid_column => auth.uid }
            resource.save(validate: false)
            resource
          end
        else
          resource = new password: Devise.friendly_token[0, 20],
                         full_name: auth.info.name,
                         picture: auth.info.image,
                         profile_attributes: { uid_column => auth.uid }
          resource.save(validate: false)
          resource
        end
        resource.after_sign_up_actions!
        resource
      end
    end
  end
end
