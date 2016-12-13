require 'find'

module Robots
  module DorRepo
    module WasCrawlPreassembly
      class BuildWasCrawlDruidTree
        include LyberCore::Robot
        include Was::Robots::Base

        def initialize
          super('dor', 'wasCrawlPreassemblyWF', 'build-was-crawl-druid-tree')
        end

        def perform(druid)
          druid_obj = Dor::Item.find(druid)
          crawl_id = Dor::WASCrawl::Utilities.get_crawl_id(druid_obj)
          source_root_pathname = Dor::Config.was_crawl.source_path
          # collection_id = Dor::WASCrawl::Utilities.get_collection_id(druid_obj)
          staging_path = Dor::Config.was_crawl.staging_path

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
