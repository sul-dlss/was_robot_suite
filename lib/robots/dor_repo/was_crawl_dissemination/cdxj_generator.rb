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
          cocina_object = Dor::Services::Client.object(druid).find

          collection_id = Dor::WasCrawl::Dissemination::Utilities.get_collection_id(cocina_object)
          collection_path = Settings.was_crawl_dissemination.stacks_collections_path + collection_id
          warc_file_list = Dor::WasCrawl::Dissemination::Utilities.warc_file_list(cocina_object)

          cdx_generator = Dor::WasCrawl::CdxjGeneratorService.new(collection_path, druid)
          cdx_generator.generate(warc_file_list)
          true
        end
      end
    end
  end
end
