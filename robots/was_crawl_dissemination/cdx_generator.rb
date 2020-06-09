module Robots
  module DorRepo
    module WasCrawlDissemination
      class CdxGenerator < Was::Robots::Base
        def initialize
          super('wasCrawlDisseminationWF', 'cdx-generator')
        end

        # `perform` is the main entry point for the robot. This is where
        # all of the robot's work is done.
        #
        # @param [String] druid -- the Druid identifier for the object to process
        def perform(druid)
          cocina_object = Dor::Services::Client.object(druid).find

          collection_id = Dor::WASCrawl::Dissemination::Utilities.get_collection_id(cocina_object)
          collection_path = Settings.was_crawl_dissemination.stacks_collections_path + collection_id
          warc_file_list = Dor::WASCrawl::Dissemination::Utilities.warc_file_list(cocina_object)

          cdx_generator = Dor::WASCrawl::CDXGeneratorService.new(collection_path, druid, warc_file_list)
          cdx_generator.generate_cdx_for_crawl
        end
      end
    end
  end
end
