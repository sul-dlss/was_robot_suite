module Was
  module Robots
    module Base
      def workflow_service
        Dor::Config.workflow.client
      end

      def client
        @client ||= Dor::Services::Client.configure(url: Dor::Config.dor_services.url,
                                                    token: Dor::Config.dor_services.token,
                                                    token_header: Dor::Config.dor_services.token_header)
      end
    end
  end
end
