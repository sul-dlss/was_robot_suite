module Robots
  module DorRepo
    module WasCrawlPreassembly
      # This job can run a long time, occasionally > 2 hours.
      class MetadataExtractor < Was::Robots::Base
        def initialize
          super('wasCrawlPreassemblyWF', 'metadata-extractor')
        end

        def perform(druid)
          cocina_model = Dor::Services::Client.object(druid).find

          # Fill the input parameters
          collection_id = Dor::WASCrawl::Utilities.get_collection_id(cocina_model)
          crawl_id = Dor::WASCrawl::Utilities.get_crawl_id(cocina_model)
          staging_path = Settings.was_crawl.staging_path

          LyberCore::Log.info "Creating MetadataExtractor with parameters #{collection_id}, #{crawl_id}, #{staging_path}, #{druid}"
          metadata_extractor_service = Dor::WASCrawl::MetadataExtractor.new(collection_id, crawl_id, staging_path.to_s, druid)
          metadata_extractor_service.run
        end
      end
    end
  end
end
