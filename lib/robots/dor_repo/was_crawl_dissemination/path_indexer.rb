# frozen_string_literal: true

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
          Dor::WasCrawl::Dissemination::Utilities.warc_file_location_info(druid) => {collection_path:, file_list:}
          path_working_directory = Settings.was_crawl_dissemination.path_working_directory

          path_indexer_service = Dor::WasCrawl::PathIndexerService.new(druid, collection_path, path_working_directory, file_list)
          path_indexer_service.merge
          path_indexer_service.sort
          path_indexer_service.publish
          # copy needed only while pywb is run in parallel with openwayback
          path_indexer_service.copy
          path_indexer_service.clean
        end
      end
    end
  end
end
