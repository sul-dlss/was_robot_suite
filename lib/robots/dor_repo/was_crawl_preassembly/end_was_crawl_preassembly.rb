# frozen_string_literal: true

module Robots
  module DorRepo
    module WasCrawlPreassembly
      class EndWasCrawlPreassembly < Base
        def initialize
          super('wasCrawlPreassemblyWF', 'end-was-crawl-preassembly')
        end

        def perform_work
          close_version # Starts the accessionWF by default
        end
      end
    end
  end
end
