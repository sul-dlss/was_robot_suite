require 'utilities'

module Robots
  module DorRepo
    module WASCrawl

      class ContentMetadataGeneratorRobot
        include LyberCore::Robot

        def initialize
          super('dor', 'wasCrawlPreassemblyWF', 'content-metadata-generator')
        end

        def perform(druid)
          obj = Dor::Item.find(druid)
          #Fill the input parameters
          collection_id = Dor::WASCrawl::Utilities::get_collection_id(druid_obj)
          staging_path = Dor::Config.was_crawl.staging_path
          metadata_generator_service = Dor::WASCrawl::ContentMetadataGenerator.new(collection_id, 
                staging_path.to_s, druid_id)
          metadata_generator_service.generate_metadata_output
        end
        
      end

    end
  end
end