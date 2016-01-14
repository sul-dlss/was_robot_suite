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
          start_completed = Dor::WorkflowService.get_workflow_status('dor', druid, 'accessionWF', 'start-accession')
          end_completed = Dor::WorkflowService.get_workflow_status('dor', druid, 'accessionWF', 'end-accession')

          if start_completed.nil? && end_completed.nil? then
            # This object isn't accessioned yet.
            druid_obj.initialize_workflow('accessionWF')
          elsif start_completed.eql?('completed') && end_completed.eql?('completed') then
            # We need to open a new version
            druid_obj.open_new_version
            druid_obj.close_version(:description => 'Updating the seed object through wasSeedPreassemblyWF', :significance => 'Major')
          elsif start_completed.eql?('completed') && !end_completed.eql?('completed') then
            # The object is still in accessioning, we have to wait until finish
            raise "Druid object #{druid} is still in accessioning, reset the end-was-seed-preassembly after accessioing completion"
          else
            raise "Druid object #{druid} is unknown status"
          end
        end
      end
    end
  end
end
