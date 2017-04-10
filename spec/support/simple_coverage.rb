if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'

  SimpleCov.start do
    add_filter "/spec/"

    add_group 'Controllers', 'app/controllers'
    add_group 'Helpers', 'app/helpers'
    add_group 'Mailers', 'app/mailers'
    add_group 'Models', 'app/models'
    add_group 'Uploaders', 'app/uploaders'
    add_group 'Views', 'app/views'
    add_group 'Libraries', 'lib'
  end
end
