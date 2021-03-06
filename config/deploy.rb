# config valid only for Capistrano 3.1
require 'capistrano/rbenv'
lock '3.2.1'

set :application, 'super_generic_website'
set :repo_url, 'https://github.com/arjabbar/super_generic_website.git'
set :rbenv_type, :system # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.3'
set :rbenv_path, '/usr/local/rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
set :use_sudo, false
# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app

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

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  before :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do 
        execute :mkdir, 'tmp/sockets'
        execute :bundle, 'install'
        execute :rbenv, 'rehash'
        execute :rake, 'db:create'
        execute :rake, 'db:migrate'
        execute :rake, 'assets:clean'
      end
    end
  end

end
