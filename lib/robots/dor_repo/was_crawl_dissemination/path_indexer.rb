module Robots
  module DorRepo
    module WasCrawlDissemination
      class PathIndexer < Base
        def initialize
          super('wasCrawlDisseminationWF', 'path-indexer')
        end

        # `perform` is the main entry point for the robot. This is where
        # all of the robot's work is done.
        #
        # @param [String] druid -- the Druid identifier for the object to process
        def perform(druid)
          cocina_object = Dor::Services::Client.object(druid).find

          collection_id = Dor::WasCrawl::Dissemination::Utilities.get_collection_id(cocina_object)
          collection_path = Settings.was_crawl_dissemination.stacks_collections_path + collection_id
          path_working_directory = Settings.was_crawl_dissemination.path_working_directory
          warc_file_list = Dor::WasCrawl::Dissemination::Utilities.warc_file_list(cocina_object)

          path_indexer_service = Dor::WasCrawl::PathIndexerService.new(druid, collection_path, path_working_directory, warc_file_list)
          path_indexer_service.merge
          path_indexer_service.sort
          path_indexer_service.publish
          path_indexer_service.clean
        end
      end
    end
  end
end
