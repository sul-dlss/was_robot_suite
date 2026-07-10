# frozen_string_literal: true

module Robots
  module DorRepo
    class Base < LyberCore::Robot
      def seed_uri
        # if the seed already made it through accessioning, there should be a descriptive note with the URI
        # this is also the field that can be updated to correct a seed URL
        uri_note = cocina_object.description.note.find { |note| note.displayLabel == 'Original site' }
        # if there is no note, then the seed is either being newly registered or
        # it did not make it to accessioning and reflects the initial registration value
        uri = uri_note&.value || cocina_object.description.title.first.value
        # in the case that the title field reflects changes made in accessioning, do not use it
        raise 'No thumbnail URL available in the description.note or description.title' unless valid_uri?(uri)

        uri
      end

      def workspace_path
        Settings.was_seed.workspace_path
      end

      private

      def valid_uri?(maybe_uri)
        uri = URI.parse(maybe_uri)
        uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      rescue URI::InvalidURIError
        false
      end
    end
  end
end
