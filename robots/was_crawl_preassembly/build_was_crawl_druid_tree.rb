require 'find'

module Robots
  module DorRepo
    module WasCrawlPreassembly
      class BuildWasCrawlDruidTree < Was::Robots::Base
        def initialize
          super('wasCrawlPreassemblyWF', 'build-was-crawl-druid-tree')
        end

        def perform(druid)
          cocina_model = Dor::Services::Client.object(druid).find

          crawl_id = Dor::WASCrawl::Utilities.get_crawl_id(cocina_model)
          source_root_pathname = Settings.was_crawl.source_path
          staging_path = Settings.was_crawl.staging_path

          druid_tree_directory = DruidTools::Druid.new(druid, staging_path)
          LyberCore::Log.info "Copying files from #{source_root_pathname}#{crawl_id}/. to #{druid_tree_directory.content_dir}"
          Find.find("#{source_root_pathname}#{crawl_id}").each do |single_file|
            next unless File.file?(single_file)

            FileUtils.cp_r single_file, druid_tree_directory.content_dir
          end
        end
      end
    end
  end
end
