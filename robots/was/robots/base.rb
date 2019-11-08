module Was
  module Robots
    module Base
      def workflow_service
        Dor::Config.workflow.client
      end

      def seed_uri(druid)
        Dor::Services::Client.object(druid).find.label
      end

      def workspace_path
        Settings.was_seed.workspace_path
      end
    end
  end
end
