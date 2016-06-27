set :application, 'was_robot_suite'
set :repo_url, 'https://github.com/sul-dlss/was_robot_suite.git'
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/lyberadmin/was_robot_suite'

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
set :linked_dirs, %w(log run config/environments config/certs jar tmp)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :stages, %w(dev stage production)
set :default_stage, 'dev'

namespace :deploy do
  desc 'Download WAS Metadata Extractor for was-crawl-preassembly'
  task :download_metadata_extractor_tar do
    on roles(:app), in: :sequence, wait: 10 do
      execute :curl, '-s https://jenkinsqa.stanford.edu/artifacts/WASMetadataExtractor-0.0.2-SNAPSHOT-jar-with-dependencies.jar', '> /home/lyberadmin/was_robot_suite/shared/jar/WASMetadataExtractor.jar'
    end
  end

  desc 'Download/unpack OpenWayback tar file to work with was-crawl-diss indexer script.'
  task :download_openwayback_tar do
    on roles(:app), in: :sequence, wait: 10 do
        execute :curl, '-s https://jenkinsqa.stanford.edu/artifacts/dist/target/openwayback.tar.gz', '> /home/lyberadmin/was_robot_suite/shared/jar/openwayback.tar.gz'
        execute :tar, '-xvf /home/lyberadmin/was_robot_suite/shared/jar/openwayback.tar.gz', '-C /home/lyberadmin/was_robot_suite/shared/jar/'
        execute :rm, '/home/lyberadmin/was_robot_suite/shared/jar/openwayback/*.war'
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
        execute :bundle, :exec, :controller, :boot
      end
    end
  end

  after :publishing, :restart
  after :restart, :download_metadata_extractor_tar
  after :restart, :download_openwayback_tar
end
