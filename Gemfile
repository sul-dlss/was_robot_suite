source 'https://rubygems.org'

gem 'druid-tools'
gem 'dor-services', '~> 5.21', '>= 5.21.0'
gem 'lyber-core', '~> 4.1', '>= 4.1.1'
gem 'robot-controller', '~> 2.0', '>= 2.1.1' # requires Resque

# need master rather than released version as of 1/18/17
gem 'bluepill', git: 'https://github.com/bluepill-rb/bluepill.git'

gem 'phantomjs'      # was-seed-preassembly thumbnail creation
gem 'mini_exiftool'  # was-seed-preassembly thumbnail creation
gem 'mini_magick'    # was-seed-preassembly thumbnail creation
gem 'assembly-image' # was-seed-preassembly thumbnail creation
gem 'rest-client'    # was-seed-dissemination does direct call to Dor rest service???
gem 'pry'            # for bin/console
gem 'slop'           # for bin/run_robot

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
