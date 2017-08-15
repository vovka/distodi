if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'

  # save to CircleCI's artifacts directory if we're on CircleCI
  if ENV['CIRCLE_ARTIFACTS']
    dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
    SimpleCov.coverage_dir(dir)
  end

  SimpleCov.start do
    add_filter ["spec", "config"]

    add_group 'Controllers', 'app/controllers'
    add_group 'Helpers', 'app/helpers'
    add_group 'Mailers', 'app/mailers'
    add_group 'Models', 'app/models'
    add_group 'Policies', 'app/policies'
    add_group 'Uploaders', 'app/uploaders'
    add_group 'Libraries', 'lib'
  end
end
