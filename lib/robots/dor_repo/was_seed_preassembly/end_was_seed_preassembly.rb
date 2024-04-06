# frozen_string_literal: true

module Robots
  module DorRepo
    module WasSeedPreassembly
      class EndWasSeedPreassembly < Base
        def initialize
          super('wasSeedPreassemblyWF', 'end-was-seed-preassembly')
        end

        def perform_work
          object_client.version.close(description: 'Closed by WAS seed preassembly robot to initiate accessioning') # Starts the accessionWF by default
        end
      end
    end
  end
end
