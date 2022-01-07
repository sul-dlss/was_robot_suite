source 'https://rubygems.org'

gem 'config', '~> 2.0'
gem 'druid-tools'
gem 'dor-services-client', '~> 7.0'
gem 'dor-workflow-client', '~> 3.22'
gem 'faraday', '~> 0.15.0'
gem 'lyber-core', '~> 6.0'
gem 'stanford-mods', '~> 2.6'

gem 'lockfile'       # file locks needed for mutual exclusion during rollup and index addition processes
gem 'mini_exiftool'  # was-seed-preassembly thumbnail creation
gem 'mini_magick'    # was-seed-preassembly thumbnail creation
gem 'assembly-image' # was-seed-preassembly thumbnail creation
gem 'pry'            # for bin/console
gem 'slop'           # for bin/run_robot
gem 'honeybadger'
gem 'rake'
gem 'resque'
gem 'resque-pool'
gem 'whenever'

group :development, :test do
  gem 'rspec'
  gem 'equivalent-xml'
  gem 'awesome_print'
  gem 'rubocop'
  gem 'simplecov'
  gem 'pry-byebug'
end

group :deployment do
  gem 'capistrano-bundler'
  gem 'capistrano-yarn' # for generating was-seed-preassembly thumbnail with chrome (PR #242)
  gem 'dlss-capistrano', '~> 3.11'
end
