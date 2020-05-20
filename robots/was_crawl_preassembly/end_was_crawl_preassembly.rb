module Robots
  module DorRepo
    module WasCrawlPreassembly
      class EndWasCrawlPreassembly < Was::Robots::Base
        def initialize
          super('wasCrawlPreassemblyWF', 'end-was-crawl-preassembly')
        end

        def perform(druid)
          object_client = Dor::Services::Client.object(druid)
          current_version = object_client.version.current
          workflow_service.create_workflow_by_name(druid, 'accessionWF', lane_id: lane_id,
                                                                         version: current_version)
        end

        private

        def lane_id
          Settings.was_crawl.dedicated_lane
        end
      end
    end
  end
end
