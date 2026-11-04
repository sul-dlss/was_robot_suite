# frozen_string_literal: true

module Robots
  module DorRepo
    module WasSeedPreassembly
      class ThumbnailGenerator < Base
        def initialize
          super('wasSeedPreassemblyWF', 'thumbnail-generator')
        end

        def perform_work
          logger.info "Creating ThumbnailGenerator with parameters #{druid}"
          # A staged jp2 is the new thumbnail, already where content-metadata-generator and accessionWF look for it.
          thumbnail = Dor::WasSeed::Thumbnail.new(druid:, cocina_model: cocina_object)
          return skipped("Using staged thumbnail #{File.basename(thumbnail.path)}") if thumbnail.path
          return skipped('Keeping existing thumbnail') if thumbnail.keep_existing?

          Dor::WasSeed::ThumbnailGeneratorService.capture_thumbnail(druid, thumbnail.content_dir, seed_uri)
        end
      end
    end
  end
end
