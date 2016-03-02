source 'https://rubygems.org'

gem 'druid-tools'

gem 'dor-services', '~> 5.4', '>= 5.4.2'
gem 'lyber-core', '~> 4.0'
gem 'robot-controller', '~> 2.0.4' # requires Resque
gem 'pry', '~> 0.10.1'          # for bin/console
gem 'slop'                      # for bin/run_robot
gem 'whenever'

gem 'rake', '>=10.3.2'

group :development, :test do
  gem 'rspec'
  gem 'awesome_print'
  gem 'coveralls', require: false
  gem 'yard'
  gem 'equivalent-xml'
end

group :deployment do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'dlss-capistrano'
end
