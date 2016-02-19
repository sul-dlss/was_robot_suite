require 'rake'
require 'rspec/core/rake_task'

task :default => :ci
task :spec => :rspec

desc 'run continuous integration suite (tests, coverage, docs)'
task :ci => [:rspec, :doc]

desc 'Run RSpec with RCov'
RSpec::Core::RakeTask.new :rspec

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
    yt.files = Dir.glob(File.join(project_root, 'robots', '**', '*.rb'))
    yt.options = ['--output-dir', doc_dest_dir, '--title', 'WAS Registrar Documentation']
  end
rescue LoadError
  desc 'Generate YARD Documentation'
  task :doc do
    abort 'Please install the YARD gem to generate rdoc.'
  end
end
