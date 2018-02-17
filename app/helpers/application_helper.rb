module ApplicationHelper
  def logout_link
    if user_signed_in?
      link_to t(".log_out"), destroy_user_session_path, method: :delete
    elsif company_signed_in?
      link_to t(".log_out"), destroy_company_session_path, method: :delete
    end
  end

  def my_panel
    if user_signed_in?
      link_to "#{current_user.first_name} #{current_user.last_name}", user_path(current_user)
    elsif company_signed_in?
      link_to current_company.first_name, company_path(current_company)
    end
  end

  def picture_show(user)
    if user.picture_url
      image_tag(user.picture.icon.url, alt: user.email, class: 'image_user')
    else
      image_tag('empty_image.png', alt: 'No image', width: 450, class: 'image_user')
    end
  end

  def service_picture_show(service)
    if service.picture_url
      image_tag(service.picture.mini.url, class: 'image_service')
    else
      image_tag('mini_empty_image.png', alt: 'No image', class: 'image_user')
    end
  end

  def translate_email(key)
    ERB.new(t(key)).result(binding).html_safe
  end

  def picture_formats
    PictureUploader::EXTENSION_WHITELIST.join(", ")
  end
end
