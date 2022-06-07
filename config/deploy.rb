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

namespace :deploy do
  desc 'Download/unpack OpenWayback tar file to work with was-crawl-diss indexer script.'
  task :download_openwayback_tar do
    on roles(:app), in: :sequence, wait: 10 do
      execute :curl, '-s https://sul-ci-prod.stanford.edu/artifacts/dist/target/openwayback.tar.gz', "> #{fetch(:deploy_to)}/shared/jar/openwayback.tar.gz"
      execute :tar, "-xvf #{fetch(:deploy_to)}/shared/jar/openwayback.tar.gz", "-C #{fetch(:deploy_to)}/shared/jar/"
      execute :rm, "#{fetch(:deploy_to)}/shared/jar/openwayback/*.war"
    end
  end

  # Download and extract JARs before restarting
  after :publishing, :download_openwayback_tar
end

# honeybadger_env otherwise defaults to rails_env
set :honeybadger_env, fetch(:stage)

# update shared_configs before restarting app
before 'deploy:publishing', 'shared_configs:update'

# Install python dependencies
before 'deploy:updated', 'pip:install'
before 'deploy:reverted', 'pip:install'

namespace :pip do
  desc 'Install python dependencies via pip'
  task :install do
    on roles(:app) do
      within release_path do
        execute(*%w[pip install -r requirements.txt])
      end
    end
  end
end
