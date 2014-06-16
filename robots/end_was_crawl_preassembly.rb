module Robots
  module DorRepo
    module WasCrawlPreassembly

      class EndWasCrawlPreassembly
        include LyberCore::Robot

        def initialize
          super('dor', 'wasCrawlPreassemblyWF', 'end-was-crawl-preassembly')          
        end

        def perform(druid)
          druid_obj = Dor::Item.find(druid)
          druid_obj.initialize_workflow('accessionWF')
        end
      end

    end
  end
end