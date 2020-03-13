module Robots
  module DorRepo
    module WasSeedPreassembly
      class DescMetadataGenerator
        include LyberCore::Robot
        include Was::Robots::Base

        def initialize
          super('dor', 'wasSeedPreassemblyWF', 'desc-metadata-generator')
        end

        def perform(druid)
          LyberCore::Log.info "Creating DescMetadataGenerator with parameters #{druid}"
          metadata_generator_service = Dor::WASSeed::DescMetadataGenerator.new(workspace_path,
                                                                               druid,
                                                                               seed_uri(druid),
                                                                               collection_id(druid))
          metadata_generator_service.generate_metadata_output
        end

        private

        def collection_id(druid)
          collections = Dor::Services::Client.object(druid).collections
          raise "Expect only one collection for #{druid} but found #{collections.size}" unless collections.size == 1
          collections[0].externalIdentifier
        end
      end
    end
  end
end
