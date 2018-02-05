require 'bundler'
require 'rake'
require 'robot-controller/tasks'

# Import external rake tasks
Dir.glob('lib/tasks/*.rake').each { |r| import r }

task default: :ci

desc 'run continuous integration suite (tests & coverage)'
task ci: [:spec, :rubocop]

begin
  require 'rspec/core/rake_task'
  desc 'Run RSpec'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  desc 'Run RSpec'
  task :spec do
    abort 'Please install the rspec gem to run tests.'
  end
end

task :environment do
  require_relative 'config/boot'
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError
  desc 'Run rubocop'
  task :rubocop do
    abort 'Please install the rubocop gem to run rubocop.'
  end
end
