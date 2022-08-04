# frozen_string_literal: true

module Robots
  module DorRepo
    module WasSeedPreassembly
      class ThumbnailGenerator < Base
        def initialize
          super('wasSeedPreassemblyWF', 'thumbnail-generator')
        end

        def perform(druid)
          LyberCore::Log.info "Creating ThumbnailGenerator with parameters #{druid}"
          Dor::WasSeed::ThumbnailGeneratorService.capture_thumbnail(druid, workspace_path, original_site_uri(druid))
        end
      end
    end
  end
end
