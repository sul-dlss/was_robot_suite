module Robots
  module DorRepo
    module WasSeedPreassembly

      class ContentMetadataGenerator
        include LyberCore::Robot

        def initialize
          super('dor', 'wasSeedPreassemblyWF', 'content-metadata-generator')
        end

        def perform(druid)
          workspace_path = Dor::Config.was_crawl.workspace_path
          LyberCore::Log.info "Creating ContentMetadataGenerator with parameters  #{workspace_path}, #{druid}"

          metadata_generator_service = Dor::WASSeed::ContentMetadataGenerator.new(workspace_path, druid)
          metadata_generator_service.generate_metadata_output
        end
        
      end

    end
  end
end