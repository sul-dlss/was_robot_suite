# config valid only for Capistrano 3.1
# lock '3.2.1'

set :application, 'was-crawl-dissemination'
set :repo_url, 'https://github.com/sul-dlss/was-crawl-dissemination.git'
# set :branch, 'demoWF'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/lyberadmin/was-crawl-diss'
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

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

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :stages, %W(development staging production)
set :default_stage, 'development'
set :linked_dirs, %w(log run config/environments config/certs jar)

namespace :deploy do
  # This is a try to configure a clean install
  # desc 'Start application' 6677778876788888g
  # task :start do
  #   invoke 'deploy'
  #  on roles(:app), in: :sequence, wait: 10 do
  #    within release_path do
  #      execute :bundle, :install
  #      execute :bundle, :exec, :controller, :boot
  #    end
  #  end
  # end
  desc 'Download/unpack OpenWayback tar file to work with indexer script.'
  task :download_openwayback_tar do
    on roles(:app), in: :sequence, wait: 10 do
        execute :curl, '-s https://jenkinsqa.stanford.edu/artifacts/dist/target/openwayback.tar.gz', '> /home/lyberadmin/was-crawl-diss/shared/jar/openwayback.tar.gz'
        execute :tar, '-xvf /home/lyberadmin/was-crawl-diss/shared/jar/openwayback.tar.gz', '-C /home/lyberadmin/was-crawl-diss/shared/jar/'
        execute :rm, '/home/lyberadmin/was-crawl-diss/shared/jar/openwayback/*.war'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 10 do
      within release_path do
        # Uncomment  with the first deploy
        # execute :bundle, :install

        # Comment with the first deploy
        test :bundle, :exec, :controller, :stop
        test :bundle, :exec, :controller, :quit

        # Always call the boot
        execute :bundle, :exec, :controller, :boot

      end
    end
  end

  after :publishing, :restart
  after :restart, :download_openwayback_tar
end
