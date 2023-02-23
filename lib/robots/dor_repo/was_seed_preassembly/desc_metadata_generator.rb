# frozen_string_literal: true

module Robots
  module DorRepo
    module WasSeedPreassembly
      class DescMetadataGenerator < Base
        def initialize
          super('wasSeedPreassemblyWF', 'desc-metadata-generator')
        end

        def perform_work
          logger.info "Creating DescMetadataGenerator with parameters #{druid}"
          metadata_generator_service = Dor::WasSeed::DescMetadataGenerator.new(workspace_path,
                                                                               druid,
                                                                               seed_uri,
                                                                               collection_id,
                                                                               logger: logger)
          metadata_generator_service.generate_metadata_output
        end

        private

        def collection_id
          collections = object_client.collections
          raise "Expect only one collection for #{druid} but found #{collections.size}" unless collections.size == 1

          collections[0].externalIdentifier
        end
      end
    end
  end
end
