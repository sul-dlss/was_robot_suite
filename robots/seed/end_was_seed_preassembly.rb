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
          
          if Dor::WorkflowService.get_lifecycle('dor', druid, 'registered').nil? then 
            druid_obj.open_new_version
            druid_obj.close_version( {:description=>"Updating the seed object through wasSeedPreassemblyWF", :significance=>"Major"})
          else
            druid_obj.initialize_workflow('accessionWF')
          end
          
        end
      end

    end
  end
end