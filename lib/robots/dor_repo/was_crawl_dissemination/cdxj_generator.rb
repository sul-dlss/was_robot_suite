# frozen_string_literal: true

module Robots
  module DorRepo
    module WasCrawlDissemination
      class CdxjGenerator < Base
        def initialize
          super('wasCrawlDisseminationWF', 'cdxj-generator')
        end

        # `perform` is the main entry point for the robot. This is where
        # all of the robot's work is done.
        #
        # @param [String] druid -- the Druid identifier for the object to process
        def perform(druid)
          Dor::WasCrawl::Dissemination::Utilities.warc_file_location_info(druid) => {collection_path:, file_list:}

          cdx_generator = Dor::WasCrawl::CdxjGeneratorService.new(collection_path, druid)
          cdx_generator.generate(file_list)
          true
        end
      end
    end
  end
end
