# frozen_string_literal: true

module Robots
  module DorRepo
    module WasSeedPreassembly
      class EndWasSeedPreassembly < Base
        def initialize
          super('wasSeedPreassemblyWF', 'end-was-seed-preassembly')
        end

        def perform_work
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
