# frozen_string_literal: true

set :application, 'was_robot_suite'
set :repo_url, 'https://github.com/sul-dlss/was_robot_suite.git'
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

# Default branch is :main
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/opt/app/was/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w(config/honeybadger.yml tmp/resque-pool.lock)

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w(log config/environments config/certs config/settings jar tmp)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :deploy_environment, 'production'
set :whenever_environment, fetch(:deploy_environment)
set :default_env, { robot_environment: fetch(:deploy_environment) }
set :bundle_without, %w{deployment development test}.join(' ')

# honeybadger_env otherwise defaults to rails_env
set :honeybadger_env, fetch(:stage)

# Quiet yarn down
set :yarn_flags, '--production --silent --no-progress --non-interactive'

# update shared_configs before restarting app
before 'deploy:publishing', 'shared_configs:update'

# Install python dependencies
before 'resque:pool:hot_swap', 'poetry:install'

namespace :poetry do
  desc 'Install python dependencies via poetry and pip'
  task :install do
    on roles(:app) do
      within release_path do
        # Make sure python executables are on the PATH
        with(path: '$HOME/.local/bin:$PATH') do
          execute :pip3, :install, '-q', '--progress-bar off', '--requirement requirements.txt'
          execute :poetry, :install, '-n', '-q', '--no-ansi'
        end
      end
    end
  end
end
