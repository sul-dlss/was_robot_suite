
module Robots
  module DorRepo
    module WasCrawlPreassembly

      class BuildWasCrawlDruidTree
        include LyberCore::Robot

        def initialize
          super('dor', 'wasCrawlPreassemblyWF', 'build-was-crawl-druid-tree')
        end

        def perform(druid)
          #staging_path
          druid_obj = Dor::Item.find(druid)
          crawl_id = Dor::WASCrawl::Utilities::get_crawl_id(druid_obj)
          source_root_pathname = Dor::Config.was_crawl.source_path
          collection_id = Dor::WASCrawl::Utilities::get_collection_id(druid_obj)
          staging_path = Dor::Config.was_crawl.staging_path
          
          druid_tree_directory = DruidTools::Druid.new(druid,staging_path).path()
          FileUtils.cp "#{source_root_pathname}/#{crawl_id}", druid_tree_directory+"content"
        end
      end

    end
  end
end