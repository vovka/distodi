module Accessible
  extend ActiveSupport::Concern

  protected

  def check_user
    flash.clear
    if current_user || current_company
      redirect_to(root_path, notice: I18n.t('devise.failure.already_authenticated')) && return
    end
  end
end