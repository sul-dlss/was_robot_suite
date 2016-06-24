module Was
  module Robots
    module Base
      def workflow_service
        Dor::Config.workflow.client
      end
    end
  end
end
