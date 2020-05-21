module Was
  module Robots
    class Base
      include LyberCore::Robot

      def workflow_service
        WorkflowClientFactory.build
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
