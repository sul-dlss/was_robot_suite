module Robots
  module DorRepo
    module WasCrawlPreassembly
      class EndWasCrawlPreassembly
        include LyberCore::Robot
        include Was::Robots::Base

        def initialize
          super('dor', 'wasCrawlPreassemblyWF', 'end-was-crawl-preassembly')
        end

        def perform(druid)
          workflow_service.create_workflow_by_name(druid, 'accessionWF', lane_id: lane_id)
        end

        private

        def lane_id
          Dor::Config.was_crawl.dedicated_lane || 'default'
        end
      end
    end
  end
end
