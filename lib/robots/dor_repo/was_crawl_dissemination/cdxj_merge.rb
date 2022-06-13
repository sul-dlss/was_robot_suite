module Robots
  module DorRepo
    module WasCrawlDissemination
      class CdxjMerge < Base
        def initialize
          super('wasCrawlDisseminationWF', 'cdxj-merge')
        end

        # `perform` is the main entry point for the robot. This is where
        # all of the robot's work is done.
        #
        # @param [String] druid_id -- the Druid identifier for the object to process
        def perform(druid_id)
          Dor::WasCrawl::CdxjMergeService.merge(druid_id: druid_id)
        end
      end
    end
  end
end
