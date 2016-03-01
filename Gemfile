source 'https://rubygems.org'

# Ruby general dependencies
gem 'pry', '~> 0.10.0' # for bin/console
gem 'slop'             # for bin/run_robot
gem 'rake'
gem 'phantomjs'
gem 'mini_exiftool'
gem 'mini_magick'
gem 'rspec'
gem 'holepicker'
gem 'yard'

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
end

group :deployment do
  gem 'dlss-capistrano', '~> 3.2'
end
