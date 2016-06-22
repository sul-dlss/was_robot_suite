source 'https://rubygems.org'

gem 'dor-services', '~> 5.8', '>= 5.8.1'
gem 'lyber-core', '~> 4.0', '>= 4.0.3'
gem 'robot-controller', '~> 2.0.4' # requires Resque
gem 'pry', '~> 0.10.0' # for bin/console
gem 'slop'             # for bin/run_robot
gem 'rake'
gem 'rest-client'
gem 'rspec', '~> 3.3'

group :development, :test do
  gem 'yard'
  gem 'coveralls', require: false
end

group :deployment do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-bundler', '~> 1.1'
  gem 'dlss-capistrano', '~> 3.2'
end
