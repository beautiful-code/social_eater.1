# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'socialeater'
set :repo_url, 'git@github.com:ravibhim/social_eater.1.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'
set :deploy_to, "/home/deploy/app/#{fetch :application}"

set :services_for_role, {
  app: %i(app),
}

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}
set :linked_files, %w{.env config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w{log tmp/backup tmp/pids tmp/cache tmp/sockets public/assets public/system public/uploads}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  Procfile.deployed
  nginx.conf
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
))


# Unicorn settings
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
set :unicorn_binary, "bundle exec unicorn"


# rvm settings
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.1.0@socialeater --create'

namespace :foreman do
  task :export do
    on roles(:all) do
      within release_path do
        execute :bundle, "exec rvmsudo foreman export -d #{release_path} -f #{shared_path}/config/Procfile.deployed upstart /etc/init -a #{fetch :application} -u deploy"
      end
    end
  end
end



namespace :deploy do

  desc 'Install Bundler Gem version 1.5.3'
  task :install_bundler_gem do
    on roles(:all), in: :parallel do
      within release_path do
        execute :rvm, "#{fetch(:rvm_ruby_version)} do gem install bundler -v 1.5.3"
      end
    end
  end

  desc 'Create db'
  task :create_db do
    on roles(:db) do
      within release_path do
        execute :rvm, "#{fetch(:rvm_ruby_version)} do bundle exec rake db:create"
      end
    end
  end

  desc 'Deploy Environment Configs'
  task :env_configs do
    on roles(:all), in: :parallel do
      within shared_path do

        # Upload the .env into shared/
        local_location = ".environments/#{fetch :stage}/.env"
        upload! File.open(local_location), "#{shared_path}/.env" if File.exists?(local_location)

        # Upload config files into shared/config
        %w(database.yml).each do |config_file|
          local_location = ".environments/#{fetch :stage}/#{config_file}"
          if File.exists?(local_location)
            execute "mkdir -p #{shared_path}/config"
            upload! File.open(local_location), "#{shared_path}/config/#{config_file}"
          end
        end
      end
    end
  end

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "sudo start #{fetch :application}"
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "sudo stop #{fetch :application}"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo restart #{fetch :application}"
    end
  end

end

before "bundler:install", "deploy:install_bundler_gem"
before "deploy:compile_assets", "deploy:create_db"
after "deploy:compile_assets", "deploy:setup_config"
after "deploy:compile_assets", "foreman:export"
