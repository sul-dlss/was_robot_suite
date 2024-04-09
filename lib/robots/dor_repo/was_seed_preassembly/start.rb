# frozen_string_literal: true

module Robots
  module DorRepo
    module WasSeedPreassembly
      # Kicks off seed pre-assembly by making sure the item is open
      class Start < Base
        def initialize
          super('wasSeedPreassemblyWF', 'start')
        end

        def perform_work
          Honeybadger.notify('[WARNING] WAS seed pre-assembly has been started with an object that is not open') unless object_client.version.status.open?
        end
      end
    end
  end
end
