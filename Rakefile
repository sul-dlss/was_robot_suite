require 'bundler'
require 'rake'
require 'robot-controller/tasks'

# Import external rake tasks
Dir.glob('lib/tasks/*.rake').each { |r| import r }

task default: :ci

desc 'run continuous integration suite (tests, coverage, docs)'
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

# Use yard to build docs
begin
  require 'yard'
  require 'yard/rake/yardoc_task'

  project_root = File.expand_path(File.dirname(__FILE__))
  doc_dest_dir = File.join(project_root, 'doc')

  YARD::Rake::YardocTask.new(:doc) do |yt|
    yt.files = Dir.glob(File.join(project_root, 'lib', '**', '*.rb')) + Dir.glob(File.join(project_root, 'robots', '**', '*.rb'))
    yt.options = ['--output-dir', doc_dest_dir, '--readme', 'README.rdoc', '--title', 'WAS Robots Documentation']
  end
rescue LoadError
  desc 'Generate YARD Documentation'
  task :doc do
    abort 'Please install the YARD gem to generate rdoc.'
  end
end
