namespace :docker do
  namespace :assets do
    task :precompile do
      on roles(fetch(:docker_role)) do
        within release_path do
          # execute "pwd"
          # execute "ls -la"
          # execute :"docker-compose", task_command(fetch(:docker_assets_precompile_command))
          execute "docker-compose run app_unicorn rake assets:precompile"
        end
      end
    end
  end
end

# before "docker:deploy:default:run", "docker:assets:precompile"
# after 'bower:install', 'docker:assets:precompile'
