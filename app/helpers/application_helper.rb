module ApplicationHelper
  def logout_link
    if user_signed_in?
      link_to "Log out", destroy_user_session_path, method: :delete
    elsif company_signed_in?
      link_to "Log out", destroy_company_session_path, method: :delete
    end
  end

  def my_panel
    if user_signed_in?
      link_to "My panel (#{current_user.email})", user_path(current_user)
    elsif company_signed_in?
      link_to "My panel (#{current_company.email})", company_path(current_company)
    end
  end
end
