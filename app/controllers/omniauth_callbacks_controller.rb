class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def passthru
    cookies[:oauth_resource] = params[:resource]
    redirect_to "/auth/#{params[:provider]}"
  end

  def default_callback
    resource_class = cookies.delete(:oauth_resource).classify.constantize
    resource = resource_class.from_omniauth(request.env["omniauth.auth"])

    if resource.persisted?
      sign_in_and_redirect resource, :event => :authentication #this will throw if resource is not activated
      set_flash_message(:notice, :success, kind: request.env["omniauth.auth"].provider) if is_navigational_format?
    else
      redirect_to send(:"new_#{resource_name}_registration_url"), alert: resource.errors.full_messages.join("\n")
    end
  end
end
