# config valid only for Capistrano 3.1
lock '3.4'

set :rvm_type, :system
set :rvm_ruby_string, 'ruby-1.9.3-p484@was-gemsets'

set :application, 'was-crawl-preassembly'
set :repo_url, 'https://github.com/sul-dlss/was-crawl-preassembly.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/lyberadmin/was-crawl-preassembly'
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# Default value for :scm is :git
# set :scm, :git
set :scm, :git
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

set :stages, %W(dev staging production)
set :default_stage, "dev"
set :linked_dirs, %w(log run config/environments config/certs jar)

namespace :deploy do
  
  desc 'Download WAS Metadata Extractor.'
  task :download_metadata_extractor_tar do
    on roles(:app), in: :sequence, wait: 10 do
      execute :curl, "-s https://jenkinsqa.stanford.edu/artifacts/WASMetadataExtractor-0.0.2-SNAPSHOT-jar-with-dependencies.jar", "> /home/lyberadmin/was-crawl-preassembly/shared/jar/WASMetadataExtractor.jar"
    end
  end
 
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 10 do
      within release_path do
        test :bundle, :exec, :controller, :stop
        test :bundle, :exec, :controller, :quit
        execute :bundle, :exec, :controller, :boot
      end
    end
  end

  after :publishing, :restart
  after :restart, :download_metadata_extractor_tar
end
