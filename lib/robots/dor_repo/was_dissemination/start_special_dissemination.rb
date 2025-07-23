# frozen_string_literal: true

module Robots
  module DorRepo
    module WasDissemination
      class StartSpecialDissemination < Base
        def initialize
          super('wasDisseminationWF', 'start-special-dissemination')
        end

        def perform_work
          return LyberCore::ReturnState.new(status: :skipped, note: 'Not an item/DRO, nothing to do') unless cocina_object.dro?

          # Theres nothing to do if this is a seed file
          return LyberCore::ReturnState.new(status: :skipped, note: "Nothing to do for #{cocina_object.type}") unless cocina_object.type == Cocina::Models::ObjectType.webarchive_binary

          object_client.workflow('wasCrawlDisseminationWF').create(version: cocina_object.version)
        end
      end
    end
  end
end
