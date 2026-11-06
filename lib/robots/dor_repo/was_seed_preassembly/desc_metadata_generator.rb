# frozen_string_literal: true

module Robots
  module DorRepo
    module WasSeedPreassembly
      class DescMetadataGenerator < Base
        def initialize
          super('wasSeedPreassemblyWF', 'desc-metadata-generator')
        end

        def perform_work
          return skipped(skip_note) if skip_note

          logger.info "Creating descriptive metadata with parameters #{druid}"
          object_client = Dor::Services::Client.object(druid)
          cocina_model = object_client.find
          description = Dor::WasSeed::DescriptiveBuilder.build(purl: cocina_model.description.purl, seed_uri:, collection_ids:)
          updated = cocina_model.new(description:)
          object_client.update(params: updated)
        end

        private

        # @return [String, nil] why the existing description is kept, if it is
        def skip_note
          # Staged files mean this is an update, so the description may already have been edited.
          return 'Files are staged; keeping existing description' if Dor::WasSeed::StagedContent.new(druid:).any?

          # A generated description may since have been edited (e.g., in the item form or by a bulk descriptive import).
          'Description already generated; keeping existing description' if description_generated?
        end

        # The "Archived website" URL is added when the description is generated.
        def description_generated?
          Array(cocina_object.description.access&.url).any? { |url| url.displayLabel == 'Archived website' }
        end

        def collection_ids
          collections = object_client.collections
          raise "Expect at least one collection for #{druid} but found none" if collections.empty?

          collections.map(&:externalIdentifier)
        end
      end
    end
  end
end
