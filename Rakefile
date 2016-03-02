require 'bundler'
require 'rake'
require 'rake/testtask'
require 'robot-controller/tasks'

# Import external rake tasks
Dir.glob('lib/tasks/*.rake').each { |r| import r }

task :default => :ci

desc 'run continuous integration suite (tests, coverage, docs)'
task :ci => [:spec, :doc]

begin
  require 'rspec/core/rake_task'
  desc 'Run RSpec'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  desc 'Run RSpec'
  task :doc do
    abort 'Please install the rspec gem to run tests.'
  end
end

desc 'Get application version'
task :app_version do
  puts File.read(File.expand_path('../VERSION', __FILE__)).chomp
end

task :environment do
  require_relative 'config/boot'
end

# Use yard to build docs
begin
  require 'yard'
  require 'yard/rake/yardoc_task'

  project_root = File.expand_path(File.dirname(__FILE__))
  doc_dest_dir = File.join(project_root, 'doc')

  YARD::Rake::YardocTask.new(:doc) do |yt|
    yt.files = Dir.glob(File.join(project_root, 'lib', '**', '*.rb')) +
               [File.join(project_root, 'README.rdoc')]
    yt.options = ['--output-dir', doc_dest_dir, '--readme', 'README.rdoc', '--title', 'WAS Registrar Documentation']
  end
rescue LoadError
  desc 'Generate YARD Documentation'
  task :doc do
    abort 'Please install the YARD gem to generate rdoc.'
  end
end
