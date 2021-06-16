module Robots
  module DorRepo
    module WasSeedPreassembly
      class EndWasSeedPreassembly < Was::Robots::Base
        def initialize
          super('wasSeedPreassemblyWF', 'end-was-seed-preassembly')
        end

        def perform(druid)
          object_client = Dor::Services::Client.object(druid)
          object_client.accession.start(
            workflow: 'accessionWF',
            significance: 'major',
            description: 'wasSeedPreassembly'
          )
        end
      end
    end
  end
end
