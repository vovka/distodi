module UsersHelper
  def picture_show
    if @user.picture_url
      image_tag(@user.picture_url, alt: @user.email, class: 'image_user')
    else
      image_tag('empty_image.png', alt: 'No image', width: 450, class: 'image_user')
    end

  end
end
