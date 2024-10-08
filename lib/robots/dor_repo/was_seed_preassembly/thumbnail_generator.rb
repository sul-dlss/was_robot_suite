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
          Dor::WasSeed::ThumbnailGeneratorService.capture_thumbnail(druid, workspace_path, original_site_uri)
        end

        private

        def original_site_uri
          # if the seed already made it through accessioning, there should be a descriptive note with the URI
          # this is also the field that can be updated to correct a seed URL
          uri_note = cocina_object.description.note.find { |note| note.displayLabel == 'Original site' }
          # if there is no note, then the seed is either being newly registered or
          # it did not make it to accessioning and reflects the initial registration value
          uri = uri_note&.value || cocina_object.description.title.first.value
          # in the case that the title field reflects changes made in accessioning, do not use it
          raise StandardError, 'No thumbnail URL available in the description.note or description.title' if uri.start_with?('Web Archive Seed for')

          uri
        end
      end
    end
  end
end
