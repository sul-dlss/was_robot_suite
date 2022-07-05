# frozen_string_literal: true

module Robots
  module DorRepo
    module WasDissemination
      class StartSpecialDissemination < Base
        def initialize
          super('wasDisseminationWF', 'start-special-dissemination')
        end

        # `perform` is the main entry point for the robot. This is where
        # all of the robot's work is done.
        #
        # @param [String] druid -- the Druid identifier for the object to process
        def perform(druid)
          obj = Dor::Services::Client.object(druid).find
          return LyberCore::Robot::ReturnState.new(status: :skipped, note: 'Not an item/DRO, nothing to do') unless obj.dro?

          # Theres nothing to do if this is a seed file
          return LyberCore::Robot::ReturnState.new(status: :skipped, note: "Nothing to do for #{obj.type}") unless obj.type == Cocina::Models::ObjectType.webarchive_binary

          workflow_service.create_workflow_by_name(druid, 'wasCrawlDisseminationWF', version: obj.version)
        end
      end
    end
  end
end
