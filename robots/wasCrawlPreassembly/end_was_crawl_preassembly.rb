require 'dor/services/client'

module Robots
  module DorRepo
    module WasCrawlPreassembly
      class EndWasCrawlPreassembly
        include LyberCore::Robot
        include Was::Robots::Base

        def initialize
          super('dor', 'wasCrawlPreassemblyWF', 'end-was-crawl-preassembly')
        end

        def perform(druid)
          opts = { create_ds: true }
          opts[:lane_id] = Dor::Config.was_crawl.dedicated_lane.nil? ? 'default' : Dor::Config.was_crawl.dedicated_lane
          workflow_service.create_workflow('dor', druid, 'accessionWF', initial_workflow, opts)
        end

        private

        def initial_workflow
          client.workflows.initial(name: 'accessionWF')
        end

        def client
          @client ||= Dor::Services::Client.configure(url: Dor::Config.dor_services.url,
                                                      token: Dor::Config.dor_services.token,
                                                      token_header: Dor::Config.dor_services.token_header)
        end
      end
    end
  end
end
