module Robots
  module DorRepo
    module WasCrawlPreassembly

      class EndWasCrawlPreassembly
        include LyberCore::Robot

        def initialize
          super('dor', 'wasCrawlPreassemblyWF', 'end-was-crawl-preassembly')          
        end

        def perform(druid)
          obj = Dor::Item.find(druid)
          obj.clear_diff_cache
          Dor::WorkflowService.update_workflow_status('dor', druid, 'assemblyWF', 'cleanup', 'waiting')
        end
      end

    end
  end
end