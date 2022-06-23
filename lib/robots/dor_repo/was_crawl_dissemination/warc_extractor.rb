module Robots
  module DorRepo
    module WasCrawlDissemination
      # Extracts WARC files from a WACZ file.
      class WarcExtractor < Base
        def initialize
          super('wasCrawlDisseminationWF', 'warc-extractor')
        end

        # `perform` is the main entry point for the robot. This is where
        # all of the robot's work is done.
        #
        # @param [String] druid -- the Druid identifier for the object to process
        def perform(druid)
          cocina_object = Dor::Services::Client.object(druid).find

          collection_id = Dor::WasCrawl::Dissemination::Utilities.get_collection_id(cocina_object)
          collection_path = Settings.was_crawl_dissemination.stacks_collections_path + collection_id
          base_path = DruidTools::AccessDruid.new(druid, collection_path).path
          wacz_file_list = Dor::WasCrawl::Dissemination::Utilities.wacz_file_list(cocina_object)

          wacz_file_list.each { |filename| Dor::WasCrawl::WarcExtractorService.extract(base_path, filename) }
        end
      end
    end
  end
end
