class ItemNotSpecifiedException < StandardError
end

class NotAuthenticatedError < StandardError
end

class ApplicationController < ActionController::Base
  include Pundit

  devise_group :user_or_company, contains: [:company, :user]
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_lead
  before_action :set_layout, only: :home
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def set_lead
    @lead = Lead.new
  end

  def after_sign_in_path_for(resource)
    resource
  end

  private

    def redirect_back(default = root_url)
      if request.env["HTTP_REFERER"].present? &&
         request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
        redirect_to :back
      else
        redirect_to default
      end
    end

    def user_not_authorized
      not_found
    end

    def not_found
      raise ActionController::RoutingError, "Not Found"
    end

    def set_layout
      layout = if params.include?(:new)
        "new"
      else
        "application"
      end
      self.class.layout(layout)
    end
end
