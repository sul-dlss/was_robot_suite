# frozen_string_literal: true

module Robots
  module DorRepo
    class Base < LyberCore::Robot
      def seed_uri
        cocina_object.label
      end

      def workspace_path
        Settings.was_seed.workspace_path
      end
    end
  end
end
