# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'distodi'
set :repo_url, 'git@bitbucket.org:distodi/distodi.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/apps/distodi"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
set :format, :pretty

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, false

# Default value for :linked_files is []
append :linked_files, '.rbenv-vars'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/sockets'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :unicorn_config_path, -> { File.join(current_path, "config", "unicorn.rb") }
set :unicorn_rack_env, -> { fetch(:rails_env) }
# set :unicorn_pid, -> { File.join(current_path, "tmp/pids/unicorn.pid") }
set :sidekiq_config, -> { File.join(current_path, 'config', 'sidekiq.yml') }
