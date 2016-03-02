source 'https://rubygems.org'

gem 'dor-services', '~> 5.5', '>= 5.5.0'
gem 'lyber-core', '~> 4.0', '>= 4.0.2'
gem 'robot-controller', '~> 2.0.4' # requires Resque
gem 'pry', '~> 0.10.1'     # for bin/console
gem 'slop'  # for bin/run_robot
gem 'rake', '~> 10.3'

group :development, :test do
  gem 'coveralls', require: false
  gem 'awesome_print'
  gem 'rspec'
  gem 'yard'
end

group :deployment do
  gem 'capistrano-one_time_key'
  gem 'net-ssh-krb'
  gem 'capistrano-bundler'
end
