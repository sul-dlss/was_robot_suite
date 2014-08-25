source 'https://rubygems.org'

gem "rest-client"
gem "druid-tools"
gem 'capistrano-one_time_key'
gem 'net-ssh-krb'

gem 'addressable', '2.3.5'      # pin to avoid RDF bug
gem 'dor-services', '~> 4.8'
gem 'lyber-core', '~> 3.2', '>=3.2.4'
gem 'robot-controller', '~> 1.0' # requires Resque
gem 'pry', '~> 0.10.0'          # for bin/console
gem 'slop', '~> 3.5.0'          # for bin/run_robot
gem 'rake', '~> 10.3.2'

group :development do
  gem 'awesome_print'
end

gem "rspec", "2.14.1"

group :deployment do
  gem 'lyberteam-capistrano-devel'
  gem 'capistrano-bundler'
end
