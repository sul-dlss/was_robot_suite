module Robots
  module DorRepo
    module WasCrawlPreassembly
      class TechnicalMetadataGenerator < Was::Robots::Base
        def initialize
          super('wasCrawlPreassemblyWF', 'technical-metadata-generator')
        end

        def perform(druid)
          cocina_model = Dor::Services::Client.object(druid).find

          # Fill the input parameters
          collection_id = Dor::WASCrawl::Utilities.get_collection_id(cocina_model)
          staging_path = Settings.was_crawl.staging_path

          LyberCore::Log.info "Creating TechnicalMetadataGenerator with parameters #{collection_id}, #{staging_path}, #{druid}"
          metadata_generator_service = Dor::WASCrawl::TechnicalMetadataGenerator.new(collection_id,
                                                                                     staging_path.to_s, druid)
          metadata_generator_service.generate_metadata_output
        end
      end
    end
  end
end