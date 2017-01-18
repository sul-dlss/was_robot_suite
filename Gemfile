source 'https://rubygems.org'

gem 'druid-tools'

gem 'dor-services', '~> 5.8', '>= 5.8.2'
gem 'lyber-core', '~> 4.0', '>= 4.0.3'
gem 'robot-controller', '~> 2.0.4' # requires Resque
gem 'phantomjs'      # was-seed-preassembly thumbnail creation
gem 'mini_exiftool'  # was-seed-preassembly thumbnail creation
gem 'mini_magick'    # was-seed-preassembly thumbnail creation
gem 'assembly-image' # was-seed-preassembly thumbnail creation
gem 'rest-client'    # was-seed-dissemination does direct call to Dor rest service???
gem 'pry', '~> 0.10.1'          # for bin/console
gem 'slop'                      # for bin/run_robot
gem 'honeybadger', '~> 2.0'

gem 'rake'

group :development, :test do
  gem 'rspec'
  gem 'coveralls', require: false
  gem 'codeclimate-test-reporter', require: false
  gem 'yard'
  gem 'equivalent-xml'
  gem 'awesome_print'
  gem 'rubocop'
  gem 'pry-byebug'
end

group :deployment do
  gem 'capistrano-bundler'
  gem 'dlss-capistrano'
end
