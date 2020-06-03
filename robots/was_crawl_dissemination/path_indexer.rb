module Robots
  module DorRepo
    module WasCrawlDissemination
      class PathIndexer < Was::Robots::Base
        def initialize
          super('wasCrawlDisseminationWF', 'path-indexer')
        end

        # `perform` is the main entry point for the robot. This is where
        # all of the robot's work is done.
        #
        # @param [String] druid -- the Druid identifier for the object to process
        def perform(druid)
          druid_obj = Dor.find(druid)
          cocina_object = Dor::Services::Client.object(druid).find

          collection_id = Dor::WASCrawl::Dissemination::Utilities.get_collection_id(cocina_object)
          collection_path = Settings.was_crawl_dissemination.stacks_collections_path + collection_id
          path_working_directory = Settings.was_crawl_dissemination.path_working_directory
          contentMetadata = druid_obj.datastreams['contentMetadata']
          warc_file_list = Dor::WASCrawl::Dissemination::Utilities.get_warc_file_list_from_content_metadata(contentMetadata.content)

          path_indexer_service = Dor::WASCrawl::PathIndexerService.new(druid, collection_path, path_working_directory, warc_file_list)
          path_indexer_service.merge
          path_indexer_service.sort
          path_indexer_service.publish
          path_indexer_service.clean
        end
      end
    end
  end
end
