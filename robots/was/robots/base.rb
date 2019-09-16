module Was
  module Robots
    module Base
      def workflow_service
        Dor::Config.workflow.client
      end

      def client
        @client ||= Dor::Services::Client.configure(url: Dor::Config.dor_services.url,
                                                    token: Dor::Config.dor_services.token)
      end

      def seed_uri(druid)
        client.object(druid).find.label
      end

      def workspace_path
        Dor::Config.was_seed.workspace_path
      end
    end
  end
end
