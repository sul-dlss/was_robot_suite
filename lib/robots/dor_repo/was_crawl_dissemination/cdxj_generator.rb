# frozen_string_literal: true

module Robots
  module DorRepo
    module WasCrawlDissemination
      class CdxjGenerator < Base
        def initialize
          super('wasCrawlDisseminationWF', 'cdxj-generator')
        end

        def perform_work
          Dor::WasCrawl::Dissemination::Utilities.warc_file_location_info(druid) => { collection_path:, file_list: }

          cdx_generator = Dor::WasCrawl::CdxjGeneratorService.new(collection_path, druid)
          cdx_generator.generate(file_list)
          true
        end
      end
    end
  end
end
