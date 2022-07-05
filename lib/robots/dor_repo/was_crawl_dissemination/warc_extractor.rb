# frozen_string_literal: true

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
          Dor::WasCrawl::Dissemination::Utilities.wacz_file_location_info(druid) => {item_path:, file_list:}

          file_list.each { |filename| Dor::WasCrawl::WarcExtractorService.extract(item_path, filename) }
        end
      end
    end
  end
end
