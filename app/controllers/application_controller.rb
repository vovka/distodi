class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_lead

  def set_lead
    @lead = Lead.new
  end

  def after_sign_in_path_for(_ = nil)
    if user_signed_in?
      current_user
    elsif company_signed_in?
      current_company
    end
  end

  alias_method :current_user_or_company, :after_sign_in_path_for

  private

    def redirect_back(default = root_url)
      if request.env["HTTP_REFERER"].present? &&
         request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
        redirect_to :back
      else
        redirect_to default
      end
    end
end
