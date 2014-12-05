module Robots
  module DorRepo
    module WasSeedPreassembly

      class EndWasSeedPreassembly
        include LyberCore::Robot

        def initialize
          super('dor', 'wasSeedPreassemblyWF', 'end-was-seed-preassembly')          
        end

        def perform(druid)
          druid_obj = Dor::Item.find(druid)
          druid_obj.initialize_workflow('accessionWF')
        end
      end

    end
  end
end