class ActionView::TestCase::TestController
  def default_url_options
    super.merge({ :locale => I18n.default_locale })
  end

  def url_options
    default_url_options
  end
end
