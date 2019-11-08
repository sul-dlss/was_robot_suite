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
          start_completed = workflow_service.workflow_status('dor', druid, 'accessionWF', 'start-accession')
          end_completed = workflow_service.workflow_status('dor', druid, 'accessionWF', 'end-accession')

          if start_completed.nil? && end_completed.nil?
            # This object isn't accessioned yet.
            workflow_service.create_workflow_by_name(druid, 'accessionWF')
          elsif start_completed.eql?('completed') && end_completed.eql?('completed')
            # We need to open a new version
            version_client = Dor::Services::Client.object(druid).version
            version_client.open
            version_client.close(description: 'Updating the seed object through wasSeedPreassemblyWF', significance: 'Major')
          elsif start_completed.eql?('completed') && !end_completed.eql?('completed')
            # The object is still in accessioning, we have to wait until finish
            fail "Druid object #{druid} is still in accessioning, reset the end-was-seed-preassembly after accessioning completion"
          else
            fail "Druid object #{druid} is unknown status"
          end
        end
      end
    end
  end
end
