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
          workflow_service.create_workflow_by_name(druid, 'accessionWF',
                                                   lane_id: lane_id,
                                                   version: current_version(druid))
        end

        private

        def lane_id
          Settings.was_crawl.dedicated_lane
        end
      end
    end
  end
end
