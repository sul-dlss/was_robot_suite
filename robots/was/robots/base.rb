module Was
  module Robots
    module Base
      def workflow_service
        Dor::Config.workflow.client
      end

      def seed_uri(druid)
        object_client(druid).find.label
      end

      def object_client(druid)
        Dor::Services::Client.object(druid)
      end

      def version_client(druid)
        object_client(druid).version
      end

      def current_version(druid)
        version_client(druid).current.to_i
      end

      def workspace_path
        Settings.was_seed.workspace_path
      end
    end
  end
end
