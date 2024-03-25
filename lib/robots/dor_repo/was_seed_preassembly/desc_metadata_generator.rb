# frozen_string_literal: true

module Robots
  module DorRepo
    module WasSeedPreassembly
      class DescMetadataGenerator < Base
        def initialize
          super('wasSeedPreassemblyWF', 'desc-metadata-generator')
        end

        def perform_work
          logger.info "Creating descriptive metadata with parameters #{druid}"
          object_client = Dor::Services::Client.object(druid)
          cocina_model = object_client.find
          description = Dor::WasSeed::DescriptiveBuilder.build(purl: cocina_model.description.purl, seed_uri:, collection_id:)
          updated = cocina_model.new(description:)
          object_client.update(params: updated)
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
