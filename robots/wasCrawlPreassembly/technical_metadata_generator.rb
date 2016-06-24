module Robots
  module DorRepo
    module WasCrawlPreassembly
      class TechnicalMetadataGenerator
        include LyberCore::Robot
        include Was::Robots::Base

        def initialize
          super('dor', 'wasCrawlPreassemblyWF', 'technical-metadata-generator')
        end

        def perform(druid)
          druid_obj = Dor::Item.find(druid)
          # Fill the input parameters
          collection_id = Dor::WASCrawl::Utilities.get_collection_id(druid_obj)
          staging_path = Dor::Config.was_crawl.staging_path

          LyberCore::Log.info "Creating TechnicalMetadataGenerator with parameters #{collection_id}, #{staging_path.to_s}, #{druid}"
          metadata_generator_service = Dor::WASCrawl::TechnicalMetadataGenerator.new(collection_id,
            staging_path.to_s, druid)
          metadata_generator_service.generate_metadata_output
        end
      end
    end
  end
end
