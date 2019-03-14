source 'https://rubygems.org'

gem 'druid-tools'
gem 'dor-services', '~> 5.24'
gem 'dor-services-client', '~> 1.2'
gem 'faraday', '~> 0.15.0'
gem 'lyber-core', '~> 4.1', '>= 4.1.1'
gem 'robot-controller', '~> 2.1', '>= 2.1.1' # requires Resque
gem 'bluepill', '~> 0.1.3'

gem 'lockfile'       # file locks needed for mutual exclusion during rollup and index addition processes
gem 'phantomjs'      # was-seed-preassembly thumbnail creation
gem 'mini_exiftool'  # was-seed-preassembly thumbnail creation
gem 'mini_magick'    # was-seed-preassembly thumbnail creation
gem 'assembly-image' # was-seed-preassembly thumbnail creation
gem 'rest-client'    # was-seed-dissemination does direct call to Dor rest service???
gem 'pry'            # for bin/console
gem 'slop'           # for bin/run_robot
gem 'honeybadger', '~> 2.0'

gem 'rake'

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
  gem 'dlss-capistrano'
end
