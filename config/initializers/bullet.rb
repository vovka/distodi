unless Rails.env.production?
  Rails.application.configure do
    config.after_initialize do
      Bullet.enable = true
      Bullet.rails_logger = true
      Bullet.add_footer = true
      # Bullet.stacktrace_includes = [ 'your_gem', 'your_middleware' ]
      # Bullet.stacktrace_excludes = [ 'their_gem', 'their_middleware' ]
      if Rails.env.test?
        Bullet.raise = true
      end
    end
  end
end
