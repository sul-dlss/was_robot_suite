# frozen_string_literal: true

module Robots
  module DorRepo
    module WasSeedPreassembly
      class ContentMetadataGenerator < Base
        def initialize
          super('wasSeedPreassemblyWF', 'content-metadata-generator')
        end

        def perform_work
          object_client = Dor::Services::Client.object(druid)
          cocina_model = object_client.find
          thumbnail = Dor::WasSeed::Thumbnail.new(druid:, cocina_model:)
          logger.info "Creating ContentMetadataGenerator with parameters  #{thumbnail.content_dir}, #{druid}"

          # thumbnail-generator kept the existing thumbnail, so keep the existing structure.
          return skipped('No new thumbnail; keeping existing structure') if thumbnail.keep_existing?
          raise "No jp2 thumbnail found in #{thumbnail.content_dir}" unless thumbnail.path

          object_file = Assembly::ObjectFile.new(thumbnail.path, file_attributes: { preserve: 'no', shelve: 'yes', publish: 'yes' })

          structural = Dor::WasSeed::StructuralBuilder.build(cocina_model:, thumbnail: object_file)
          updated = cocina_model.new(structural:)
          object_client.update(params: updated)
        end
      end
    end
  end
end
