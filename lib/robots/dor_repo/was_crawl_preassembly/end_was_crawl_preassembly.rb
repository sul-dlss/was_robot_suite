# frozen_string_literal: true

module Robots
  module DorRepo
    module WasCrawlPreassembly
      class EndWasCrawlPreassembly < Base
        def initialize
          super('wasCrawlPreassemblyWF', 'end-was-crawl-preassembly')
        end

        def perform_work
          current_version = object_client.version.current
          workflow_service.create_workflow_by_name(druid, 'accessionWF', lane_id: was_lane_id,
                                                                         version: current_version)
        end

        private

        def was_lane_id
          Settings.was_crawl.dedicated_lane
        end
      end
    end
  end
end
