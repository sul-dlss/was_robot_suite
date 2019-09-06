module Robots
  module DorRepo
    module WasSeedPreassembly
      class ThumbnailGenerator
        include LyberCore::Robot
        include Was::Robots::Base

        def initialize
          super('dor', 'wasSeedPreassemblyWF', 'thumbnail-generator')
        end

        def perform(druid)
          LyberCore::Log.info "Creating ThumbnailGenerator with parameters #{druid}"
          Dor::WASSeed::ThumbnailGeneratorService.capture_thumbnail(druid, workspace_path, seed_uri(druid))
        end

        private

        def seed_uri(druid)
          client.object(druid).find.label
        end

        def workspace_path
          Dor::Config.was_seed.workspace_path
        end
      end
    end
  end
end
