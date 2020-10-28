source 'https://rubygems.org'

gem 'config', '~> 2.0'
gem 'druid-tools'
gem 'dor-services', '~> 9.0'
gem 'dor-services-client', '~> 6.0'
gem 'dor-workflow-client', '~> 3.22'
gem 'faraday', '~> 0.15.0'
gem 'lyber-core', '~> 6.0'

gem 'lockfile'       # file locks needed for mutual exclusion during rollup and index addition processes
gem 'mini_exiftool'  # was-seed-preassembly thumbnail creation
gem 'mini_magick'    # was-seed-preassembly thumbnail creation
gem 'assembly-image' # was-seed-preassembly thumbnail creation
gem 'rest-client'    # was-seed-dissemination to call was-thumbnail-service
gem 'pry'            # for bin/console
gem 'slop'           # for bin/run_robot
gem 'honeybadger'
gem 'rake'
gem 'resque'
gem 'resque-pool'
gem 'whenever'

group :development, :test do
  gem 'rspec'
  gem 'equivalent-xml'
  gem 'awesome_print'
  gem 'rubocop'
  # Codeclimate is not compatible with 0.18+. See https://github.com/codeclimate/test-reporter/issues/413
  gem 'simplecov', '~> 0.17.1', require: false
  gem 'pry-byebug'
end

group :deployment do
  gem 'capistrano-bundler'
  gem 'capistrano-yarn'
  gem 'dlss-capistrano'
end
