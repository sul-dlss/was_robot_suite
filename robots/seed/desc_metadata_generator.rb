module Robots
  module DorRepo
    module WasSeedPreassembly

      class DescMetadataGenerator
        include LyberCore::Robot

        def initialize
          super('dor', 'wasSeedPreassemblyWF', 'desc-metadata-generator')
        end

        def perform(druid)
          workspace_path = Dor::Config.was_crawl.workspace_path
          LyberCore::Log.info "Creating DescMetadataGenerator with parameters #{collection_id}, #{staging_path.to_s}, #{druid}"

          metadata_generator_service = Dor::WASSeed::DescMetadataGenerator.new(workspace_path, druid)
          metadata_generator_service.generate_metadata_output
       end
      end

    end
  end
end