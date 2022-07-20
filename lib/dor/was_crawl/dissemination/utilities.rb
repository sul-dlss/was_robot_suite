# frozen_string_literal: true

module Dor
  module WasCrawl
    module Dissemination
      class Utilities
        def self.run_sys_cmd(cmd_string, error_message)
          raise "Error in #{error_message} with command: #{cmd_string}\n" + $CHILD_STATUS.to_s unless system(cmd_string)
        end

        # Find WARC files on stacks
        # @param [String] druid
        # @return {Hash{collection_id=>String, collection_path=>String, item_path=>String, file_list=>Array<String>}}
        def self.warc_file_location_info(druid)
          file_location_info(druid, '*.{arc,warc}*')
        end

        # Find WACZ files on stacks
        # @param [String] druid
        # @return {Hash{collection_id=>String, collection_path=>String, item_path=>String, file_list=>Array<String>}}
        def self.wacz_file_location_info(druid)
          file_location_info(druid, '*.wacz')
        end

        def self.file_location_info(druid, glob)
          cocina_object = Dor::Services::Client.object(druid).find

          collection_id = get_collection_id(cocina_object)
          collection_path = File.join(Settings.was_crawl_dissemination.stacks_collections_path, collection_id)
          item_path = DruidTools::AccessDruid.new(druid, collection_path).path
          filenames = Dir.glob(glob, base: item_path)
          { collection_id: collection_id, collection_path: collection_path, item_path: item_path, file_list: filenames }
        end
        private_class_method :file_location_info

        def self.get_collection_id(druid_obj)
          Dor::WasCrawl::Utilities.get_collection_id(druid_obj)
        end
      end
    end
  end
end
