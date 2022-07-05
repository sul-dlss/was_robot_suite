# frozen_string_literal: true

module Dor
  module WasCrawl
    class PathIndexerService
      def initialize(druid_id, collection_path, path_working_directory, warc_file_list)
        @druid_id = druid_id
        @warc_file_list = warc_file_list
        @collection_path = collection_path

        @main_path_index_file = Settings.was_crawl_dissemination.main_path_index_file
        @pywb_main_path_index_file = Settings.was_crawl_dissemination.pywb_main_path_index_file

        @working_merged_path_index = "#{path_working_directory}/merged_path_index.txt"
        @working_sorted_duplicate_path_index = "#{path_working_directory}/duplicate_path_index.txt"
        @working_sorted_path_index = "#{path_working_directory}/path_index.txt"
      end

      def merge
        FileUtils.cp_r(@main_path_index_file, @working_merged_path_index)

        working_path_index_file = File.open(@working_merged_path_index, 'a')
        druid_base_directory = DruidTools::AccessDruid.new(@druid_id, @collection_path).path

        @warc_file_list.each do |warc_file_name|
          record = "#{warc_file_name}\t#{druid_base_directory}/#{warc_file_name}\n"
          working_path_index_file.write(record)
        end

        working_path_index_file.close
      end

      def sort
        # sort
        sort_cmd_string = "LC_ALL=C sort #{@working_merged_path_index} > #{@working_sorted_duplicate_path_index}"
        Dor::WasCrawl::Dissemination::Utilities.run_sys_cmd(sort_cmd_string, 'sorting path index file')

        # uniq
        uniq_cmd_string = "uniq #{@working_sorted_duplicate_path_index} > #{@working_sorted_path_index}"
        Dor::WasCrawl::Dissemination::Utilities.run_sys_cmd(uniq_cmd_string, 'removing duplicates from path index file')
      end

      def publish
        FileUtils.mv(@working_sorted_path_index, @main_path_index_file)
      end

      # Needed only while pywb is run in parallel with openwayback
      def copy
        FileUtils.cp(@main_path_index_file, @pywb_main_path_index_file)
      end

      def clean
        FileUtils.rm(@working_merged_path_index)
        FileUtils.rm(@working_sorted_duplicate_path_index)
      end
    end
  end
end
