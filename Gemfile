source 'https://rubygems.org'

gem 'addressable'      
gem 'dor-services', '~> 4.21.4'
gem 'lyber-core'
gem 'robot-controller', '~> 2.0.1' # requires Resque
gem 'pry'          # for bin/console
gem 'slop'          # for bin/run_robot
gem 'rake'
gem 'phantomjs'
gem 'assembly-image'
gem 'mini_exiftool'
gem 'mini_magick'
gem 'holepicker'

group :development, :test do
  gem 'webmock'
  gem 'vcr'
  gem 'rspec'
  gem 'equivalent-xml'
  gem 'awesome_print'
  gem 'debugger', :platform => :ruby_19
  gem 'yard'
  gem 'coveralls', require: false
end

group :deployment do
  gem 'capistrano', '~> 3.2.1'
  gem 'capistrano-bundler', '~> 1.1'
  gem 'lyberteam-capistrano-devel', "~> 3.0"
  gem 'capistrano-one_time_key'
end