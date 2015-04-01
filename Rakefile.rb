require 'rake'
require 'rake/testtask'
require 'robot-controller/tasks'

# Import external rake tasks
Dir.glob('lib/tasks/*.rake').each { |r| import r }

task :default  => [:rspec_run]


task :clean do
  puts 'Cleaning old coverage.data'
  FileUtils.rm('coverage.data') if(File.exists? 'coverage.data')
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

desc "Run RSpec with RCov"
RSpec::Core::RakeTask.new(:rspec_run) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rcov = true
    t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/}
end

desc 'Get application version'
task :app_version do
  puts File.read(File.expand_path('../VERSION',__FILE__)).chomp
end

task :environment do
  require_relative 'config/boot'
end