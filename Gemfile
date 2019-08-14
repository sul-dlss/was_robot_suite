source 'https://rubygems.org'

gem 'druid-tools'
gem 'dor-services', '~> 7.2'
gem 'dor-services-client', '~> 2.0'
gem 'faraday', '~> 0.15.0'
gem 'lyber-core', '~> 5.0'

gem 'lockfile'       # file locks needed for mutual exclusion during rollup and index addition processes
gem 'phantomjs'      # was-seed-preassembly thumbnail creation
gem 'mini_exiftool'  # was-seed-preassembly thumbnail creation
gem 'mini_magick'    # was-seed-preassembly thumbnail creation
gem 'assembly-image' # was-seed-preassembly thumbnail creation
gem 'rest-client'    # was-seed-dissemination to call was-thumbnail-service
gem 'pry'            # for bin/console
gem 'slop'           # for bin/run_robot
gem 'honeybadger', '~> 2.0'
gem 'rake'
gem 'resque'
gem 'resque-pool'
gem 'whenever'

group :development, :test do
  gem 'rspec'
  gem 'equivalent-xml'
  gem 'awesome_print'
  gem 'rubocop', '~> 0.58.0'
  gem 'simplecov', require: false
  gem 'pry-byebug'
end

group :deployment do
  gem 'capistrano-bundler'
  gem 'capistrano-resque-pool'
  gem 'dlss-capistrano'
end
