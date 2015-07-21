module Robots
  module DorRepo
    module WasCrawlPreassembly
      class EndWasCrawlPreassembly
        include LyberCore::Robot

        def initialize
          super('dor', 'wasCrawlPreassemblyWF', 'end-was-crawl-preassembly')          
        end

        def perform(druid)
          opts = { :create_ds => true }
          opts[:lane_id] = Dor::Config.was_crawl.dedicated_lane.nil? ? 'default' : Dor::Config.was_crawl.dedicated_lane
          Dor::WorkflowService.create_workflow('dor', druid, 'accessionWF', Dor::WorkflowObject.initial_workflow('accessionWF'), opts)
        end

      end
    end
  end
end