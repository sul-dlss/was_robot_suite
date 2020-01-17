module Robots
  module DorRepo
    module WasDissemination
      class StartSpecialDissemination
        include LyberCore::Robot
        include Was::Robots::Base

        def initialize
          super('dor', 'wasDisseminationWF', 'start-special-dissemination')
        end

        # `perform` is the main entry point for the robot. This is where
        # all of the robot's work is done.
        #
        # @param [String] druid -- the Druid identifier for the object to process
        def perform(druid)
          druid_obj = Dor.find(druid)
          return unless druid_obj.identityMetadata.objectType == ['item'] && !druid_obj.contentMetadata.nil?
          if druid_obj.contentMetadata.contentType == ['webarchive-seed']
            workflow_service.create_workflow_by_name(druid, 'wasSeedDisseminationWF', version: current_version(druid))
          elsif druid_obj.contentMetadata.contentType == ['file']
            workflow_service.create_workflow_by_name(druid, 'wasCrawlDisseminationWF', version: current_version(druid))
          end
        end
      end
    end
  end
end
