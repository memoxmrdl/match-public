# Change these


set :repo_url,        'git@github.com:memoxmrdl/match-public.git'
set :application,     'match-public'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.5.3'
set :bundle_flags, "--deployment --quiet"
set :bundle_path, -> { shared_path.join('bundle') }

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

set :rbenv_roles, :all # default value

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false  # Change to true if using ActiveRecord

## Defaults:
# set :scm,           :git
set :branch,        :develop
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_files, fetch(:linked_files, []).push("config/master.key")
set :linked_files, fetch(:linked_files, []).push("config/database.yml")

append :linked_dirs, '.bundle'

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  # task :start do
  #   on roles(:app) do
  #     execute "#{fetch(:rbenv_prefix)} puma -C /home/deploy/apps/match-public/shared/puma.rb --daemon"
  #   end
  # end

  before "deploy:starting", "puma:make_dirs"
end

namespace :setup do

end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc "setup: copy config/master.key to shared/config"
  task :copy_linked_master_key do
    on roles(:app) do
      puts ">>>>>>>>>"
      sudo :mkdir, "-pv", shared_path
      upload! "config/master.key", "#{shared_path}/config/master.key"
      sudo :chmod, "600", "#{shared_path}/config/master.key"
    end
  end

  desc "setup: copy config/database.yml"
  task :copy_linked_database_yml do
    on roles(:app) do
      puts ">>>>>>>>> database.yml"
      sudo :mkdir, "-pv", shared_path
      upload! "config/database.yml", "#{shared_path}/config/database.yml"
      #sudo :chmod, "600", "#{shared_path}/config/database.yml"
    end
  end

  desc "Make sure bundler is installer"
  task :bundle_install do
    on roles(:app) do
      execute "#{fetch(:rbenv_prefix)} gem install --force bundler -v 2.0.1"
      execute "#{fetch(:rbenv_prefix)} bundler -v"
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # invoke 'puma:restart'
      invoke 'deploy:restart_nginx'
    end
  end

  desc "setup: nginx restart"
  task :restart_nginx do
    on roles(:app) do
      puts ">>>>>>> nginx restart"
      sudo :mkdir, "-pv", "#{shared_path}/log"
      sudo :rm, "-f", "#{fetch(:nginx_sites_enabled_path)}/default"
      sudo :service, "nginx restart"
    end
  end

  # before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
  before "bundler:install", "deploy:bundle_install"
  before "deploy:check:linked_files", "deploy:copy_linked_master_key"
  before "deploy:check:linked_files", "deploy:copy_linked_database_yml"
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
