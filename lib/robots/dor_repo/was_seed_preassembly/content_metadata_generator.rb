# frozen_string_literal: true

module Robots
  module DorRepo
    module WasSeedPreassembly
      class ContentMetadataGenerator < Base
        def initialize
          super('wasSeedPreassemblyWF', 'content-metadata-generator')
        end

        def perform_work
          logger.info "Creating ContentMetadataGenerator with parameters  #{workspace_path}, #{druid}"

          object_client = Dor::Services::Client.object(druid)
          cocina_model = object_client.find
          thumbnail_path = File.join(DruidTools::Druid.new(druid, workspace_path).content_dir, 'thumbnail.jp2')
          thumbnail = Assembly::ObjectFile.new(thumbnail_path, file_attributes: { preserve: 'no', shelve: 'yes', publish: 'yes' })

          structural = Dor::WasSeed::StructuralBuilder.build(cocina_model:, thumbnail:)
          updated = cocina_model.new(structural:)
          object_client.update(params: updated)
        end
      end
    end
  end
end
