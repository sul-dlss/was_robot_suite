# frozen_string_literal: true

source 'https://rubygems.org'

# stanford dlss gems
gem 'assembly-image', '~> 2.0' # was-seed-preassembly thumbnail creation; 2.0.0 uses libvips
gem 'dor-services-client'
gem 'lyber-core', '~> 8.0'

gem 'config'
gem 'honeybadger'
gem 'lockfile'       # file locks needed for mutual exclusion during wayback index rollup and addition processes
gem 'mini_exiftool'  # was-seed-preassembly thumbnail - used to check mimetype and to get height and width
gem 'pry'            # for bin/console
gem 'rake'
gem 'rubyzip'        # warc_extractor_service
gem 'ruby-vips'      # was-seed-preassembly thumbnail creation image processing with libvips
gem 'sidekiq', '~> 7.0'
gem 'slop'           # for bin/run_robot
gem 'whenever', require: false # Work around https://github.com/javan/whenever/issues/831
gem 'zeitwerk', '~> 2.1'

source 'https://gems.contribsys.com/' do
  gem 'sidekiq-pro'
end

group :development, :test do
  gem 'awesome_print'
  gem 'debug'
  gem 'rspec'
  gem 'rubocop'
  gem 'rubocop-capybara'
  gem 'rubocop-factory_bot'
  gem 'rubocop-rspec'
  gem 'rubocop-rspec_rails'
  gem 'simplecov'
  gem 'stub_server'
end

group :deployment do
  gem 'capistrano-bundler'
  gem 'capistrano-yarn' # for generating was-seed-preassembly thumbnail with chrome (PR #242)
  gem 'dlss-capistrano', require: false
end
