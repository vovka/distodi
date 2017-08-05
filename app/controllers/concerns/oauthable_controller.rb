module OauthableController
  extend ActiveSupport::Concern

  def facebook
    common "Facebook"
  end

  def google_oauth2
    common "Google"
  end

  def twitter
    common "Twitter"
  end

  def linkedin
    common "Linkedin"
  end

  def failure
    redirect_to root_path
  end

  private

  def common(social_network_name)
    resource = resource_class.from_omniauth(request.env["omniauth.auth"])

    if resource.persisted?
      sign_in_and_redirect resource, :event => :authentication #this will throw if resource is not activated
      set_flash_message(:notice, :success, kind: social_network_name) if is_navigational_format?
    else
      redirect_to send(:"new_#{resource_name}_registration_url"), alert: resource.errors.full_messages.join("\n")
    end
  end
end
