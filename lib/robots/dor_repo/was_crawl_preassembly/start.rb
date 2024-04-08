# frozen_string_literal: true

module Robots
  module DorRepo
    module WasCrawlPreassembly
      # Kicks off crawl pre-assembly by making sure the item is open
      class Start < Base
        def initialize
          super('wasCrawlPreassemblyWF', 'start')
        end

        def perform_work
          Honeybadger.notify('[WARNING] WAS crawl pre-assembly has been started with an object that is not open') unless object_client.version.status.open?
        end
      end
    end
  end
end
