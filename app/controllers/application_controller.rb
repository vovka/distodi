class ItemNotSpecifiedException < StandardError
end

class NotAuthenticatedError < StandardError
end

class ApplicationController < ActionController::Base
  include Pundit
  include Blockchainable

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  devise_group :user_or_company, contains: [:company, :user]

  before_filter :set_notifications
  before_filter :set_locale
  before_action :set_lead

  def set_lead
    @lead = Lead.new
  end

  def after_sign_in_path_for(resource)
    user_signed_in? ? dashboard_path : current_company
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

    def pundit_user
      current_user || current_company
    end

    def set_notifications
      @notifications = ::Notification.user(current_user_or_company).active.all # ActiveAdmin requires to specify full ::namespace for the class
    end

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
      Rails.application.routes.default_url_options[:locale] = I18n.locale
    end

    def default_url_options
      { locale: I18n.locale }
    end
end
