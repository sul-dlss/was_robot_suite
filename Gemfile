source 'https://rubygems.org'

gem "rest-client"
gem "druid-tools"
gem 'capistrano-one_time_key'
gem 'net-ssh-krb'

gem 'addressable', '2.3.5'      # pin to avoid RDF bug
gem 'dor-services', '~> 4.21.4'
gem 'lyber-core', '~> 3.2', '>=3.2.4'
gem 'robot-controller', '~> 2.0.3' # requires Resque
gem 'pry', '~> 0.10.1'          # for bin/console
gem 'slop'                      # for bin/run_robot
gem "whenever"

gem 'rake', '>=10.3.2'
gem "rspec"
gem 'equivalent-xml'
gem 'coveralls', require: false
gem 'yard'

group :development do
  gem 'awesome_print'
end

group :deployment do
  gem 'lyberteam-capistrano-devel'
  gem 'capistrano-bundler'
end
