module Robots
  module DorRepo
    module WasSeedPreassembly
      class ThumbnailGenerator
        include LyberCore::Robot
        include Was::Robots::Base

        def initialize
          super('wasSeedPreassemblyWF', 'thumbnail-generator')
        end

        def perform(druid)
          LyberCore::Log.info "Creating ThumbnailGenerator with parameters #{druid}"
          Dor::WASSeed::ThumbnailGeneratorService.capture_thumbnail(druid, workspace_path, seed_uri(druid))
        end
      end
    end
  end
end
