source 'https://rubygems.org'

# Ruby general dependencies
gem 'pry', '~> 0.10.0' # for bin/console
gem 'slop'             # for bin/run_robot
gem 'rake'
gem 'phantomjs'
gem 'mini_exiftool'
gem 'mini_magick'

# DLSS dependencies
gem 'dor-services', '~> 5.5', '>= 5.5.0'
gem 'lyber-core', '~> 4.0', '>= 4.0.2'
gem 'robot-controller', '~> 2.0.4' # requires Resque
gem 'assembly-image'

group :development, :test do
  gem 'webmock'
  gem 'vcr' # only used by one pending test!
  gem 'equivalent-xml'
  gem 'coveralls', require: false
  gem 'rspec'
  gem 'yard'
end

group :deployment do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-bundler', '~> 1.1'
  gem 'dlss-capistrano', '~> 3.2'
end
