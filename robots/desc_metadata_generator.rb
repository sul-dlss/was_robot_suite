module Robots
  module DorRepo
    module WasCrawlPreassembly

      class DescMetadataGenerator
        include LyberCore::Robot

        def initialize
          super('dor', 'wasCrawlPreassemblyWF', 'desc-metadata-generator')
        end

        def perform(druid)
          obj = Dor::Item.find(druid)
          #Fill the input parameters
          collection_id = Dor::WASCrawl::Utilities::get_collection_id(druid_obj)
          staging_path = Dor::Config.was_crawl.staging_path
          metadata_generator_service = Dor::WASCrawl::DescMetadataGenerator.new(collection_id, 
            staging_path.to_s, druid)
          metadata_generator_service.generate_metadata_output
        end
      end

    end
  end
end