module Robots
  module DorRepo
    module WasSeedPreassembly
      class EndWasSeedPreassembly
        include LyberCore::Robot
        include Was::Robots::Base

        def initialize
          super('dor', 'wasSeedPreassemblyWF', 'end-was-seed-preassembly')
        end

        def perform(druid)
          druid_obj = Dor::Item.find(druid)
          start_completed = workflow_service.get_workflow_status('dor', druid, 'accessionWF', 'start-accession')
          end_completed = workflow_service.get_workflow_status('dor', druid, 'accessionWF', 'end-accession')

          if start_completed.nil? && end_completed.nil?
            # This object isn't accessioned yet.
            druid_obj.initialize_workflow('accessionWF')
          elsif start_completed.eql?('completed') && end_completed.eql?('completed')
            # We need to open a new version
            druid_obj.open_new_version
            druid_obj.close_version(:description => 'Updating the seed object through wasSeedPreassemblyWF', :significance => 'Major')
          elsif start_completed.eql?('completed') && !end_completed.eql?('completed')
            # The object is still in accessioning, we have to wait until finish
            fail "Druid object #{druid} is still in accessioning, reset the end-was-seed-preassembly after accessioing completion"
          else
            fail "Druid object #{druid} is unknown status"
          end
        end
      end
    end
  end
end
