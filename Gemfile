# frozen_string_literal: true

source 'https://rubygems.org'

# gem 'assembly-image', '~> 2.0' # was-seed-preassembly thumbnail creation; 2.0.0 uses libvips
gem 'assembly-image', git: 'https://github.com/sul-dlss/assembly-image.git'
gem 'druid-tools'
gem 'dor-services-client', '~> 12.0'
gem 'dor-workflow-client', '~> 4.0'
gem 'lyber-core', '~> 6.0'
gem 'stanford-mods', '~> 2.6'

gem 'config', '~> 2.0'
gem 'honeybadger'
gem 'lockfile'       # file locks needed for mutual exclusion during wayback index rollup and addition processes
gem 'mini_exiftool'  # was-seed-preassembly thumbnail - used to check mimetype and to get height and width
gem 'pry'            # for bin/console
gem 'rake'
gem 'resque'
gem 'resque-pool'
gem 'rubyzip'        # warc_extractor_service
gem 'ruby-vips'      # was-seed-preassembly thumbnail creation image processing with libvips
gem 'slop'           # for bin/run_robot
gem 'whenever'       # for cron jobs
gem 'zeitwerk', '~> 2.1'

group :development, :test do
  gem 'awesome_print'
  gem 'equivalent-xml'
  gem 'pry-byebug'
  gem 'rspec'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'simplecov'
  gem 'stub_server'
end

group :deployment do
  gem 'capistrano-bundler'
  gem 'capistrano-rvm', require: false
  gem 'capistrano-yarn' # for generating was-seed-preassembly thumbnail with chrome (PR #242)
  gem 'dlss-capistrano', require: false
end
