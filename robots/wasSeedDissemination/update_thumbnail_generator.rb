require 'mods'

module Robots
  module DorRepo
    module WasSeedDissemination
      class UpdateThumbnailGenerator
        include LyberCore::Robot
        include Was::Robots::Base

        def initialize
          super('dor', 'wasSeedDisseminationWF', 'update-thumbnail-generator')
        end

        # `perform` is the main entry point for the robot. This is where
        # all of the robot's work is done.
        #
        # @param [String] druid -- the Druid identifier for the object to process
        def perform(druid)
          druid_obj = Dor.find(druid)
          original_uri = get_original_uri(druid_obj.datastreams['descMetadata'].ng_xml)
          druid_id = druid_obj.id.split(':').last
          send_to_thumbnail_generator(druid_id, original_uri)
        end

        def get_original_uri(descMetadata_ng)
          original_uri = ''
          s_mods = Mods::Record.new.from_nk_node(descMetadata_ng)
          s_mods.note.map.each do |x|
            next unless x.attributes.include?('displayLabel')
            original_uri = x.text if x.attributes['displayLabel'].to_s == 'Original site'
          end
          original_uri
        end

        def send_to_thumbnail_generator(druid_id, original_uri)
          RestClient.get "#{Dor::Config.thumbnail_generator_service_uri}api/seed/create?druid=#{druid_id}&uri=#{original_uri}"
        rescue RestClient::Conflict
          LyberCore::Log.error("#{druid_id} already exists on #{Dor::Config.thumbnail_generator_service_uri}")
        end
      end
    end
  end
end
