lock "~> 3.16.0"

set :application, "food_waste"
set :repo_url, "git@github.com:anasmasood94/food_waste.git"

set :use_sudo, true
set :deploy_via, :copy
set :keep_releases, 5

set :ssh_options, {forward_agent: false}
set :log_level, :debug
set :pty, false

set :deploy_to, "/home/deployer/www/food_waste"
set :linked_files, %w{config/application.yml config/puma.rb}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle}

set :rvm1_ruby_version, 'ruby-2.7.0'
set :rvm_type, :user
set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :rvm1_map_bins, -> { fetch(:rvm_map_bins).to_a.concat(%w{rake gem bundle ruby}).uniq }

before 'deploy:assets:precompile', 'deploy:load_translations'

namespace :deploy do
  desc 'Uploads required config files'
  task :upload_configs do
    on roles(:all) do
      upload!('config/application.yml', "#{deploy_to}/shared/config/application.yml")
      upload!('config/puma.rb', "#{deploy_to}/shared/config/puma.rb")
    end
  end

  desc 'Seeds database'
  task :seed do
    on roles(:app) do
      within "#{fetch(:deploy_to)}/current/" do
        execute :bundle, :exec, :"rake db:seed RAILS_ENV=#{fetch(:stage)}"
      end
    end
  end

  desc 'Load I18n JS translations'
  task :load_translations do
    on roles(:app) do
      within "#{fetch(:deploy_to)}/current/" do
        # execute :bundle, :exec, :"rake i18n:js:export RAILS_ENV=#{fetch(:stage)}"
        execute :bundle, :exec, :"rake tmp:cache:clear RAILS_ENV=#{fetch(:stage)}"
      end
    end
  end

end

namespace :app do
  desc 'Start application'
  task :start do
    on roles(:app) do
      within "#{fetch(:deploy_to)}/current/" do
        execute :bundle, :exec, :"puma -C config/puma.rb"
      end
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      within "#{fetch(:deploy_to)}/current/" do
        execute :bundle, :exec, :'pumactl -F config/puma.rb stop'
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      within "#{fetch(:deploy_to)}/current/" do
        if test("[ -f #{deploy_to}/current/tmp/pids/puma.pid ]")
          execute :bundle, :exec, :'pumactl -F config/puma.rb stop'
        end

        execute :bundle, :exec, :"puma -C config/puma.rb"
      end
    end
  end
end
