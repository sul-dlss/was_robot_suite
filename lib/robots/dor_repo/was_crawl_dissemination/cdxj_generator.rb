module Robots
  module DorRepo
    module WasCrawlDissemination
      class CdxjGenerator < Base
        def initialize
          super('wasCrawlDisseminationWF', 'cdxj-generator')
        end

        # `perform` is the main entry point for the robot. This is where
        # all of the robot's work is done.
        #
        # @param [String] druid -- the Druid identifier for the object to process
        def perform(_druid)
          LyberCore::Robot::ReturnState.new(status: :skipped, note: 'TBD')
        end
      end
    end
  end
end
