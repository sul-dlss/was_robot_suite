source 'https://rubygems.org'

gem 'dor-services', '~> 5.8', '>= 5.8.1'
gem 'lyber-core', '~> 4.0', '>= 4.0.3'
gem 'robot-controller', '~> 2.0.4' # requires Resque
gem 'pry', '~> 0.10.1'     # for bin/console
gem 'slop'  # for bin/run_robot
gem 'rake'

group :development, :test do
  gem 'coveralls', require: false
  gem 'awesome_print'
  gem 'rspec'
  gem 'yard'
end

group :deployment do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'dlss-capistrano'
end
