# frozen_string_literal: true

module Robots
  module DorRepo
    class Base
      include LyberCore::Robot

      def workflow_service
        WorkflowClientFactory.build
      end

      def seed_uri(druid)
        Dor::Services::Client.object(druid).find.label
      end

      def original_site_uri(druid)
        cocina_object = Dor::Services::Client.object(druid).find
        uri_note = cocina_object.description.note.find { |note| note.displayLabel == 'Original site' }
        # if no original site note, use title since this is likely the first time generating
        uri = uri_note&.value || cocina_object.description.title.first.value
        return uri unless uri.start_with?('Web Archive Seed for')

        # use label if the title and note are not usable for the uri
        cocina_object.label
      end

      def workspace_path
        Settings.was_seed.workspace_path
      end
    end
  end
end
