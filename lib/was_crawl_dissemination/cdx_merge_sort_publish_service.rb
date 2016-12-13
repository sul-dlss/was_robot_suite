module Dor
  module WASCrawl
    class CDXMergeSortPublishService

      def initialize( druid_id, cdx_working_directory, cdx_backup_directory)
        @main_cdx_file = Dor::Config.was_crawl_dissemination.main_cdx_file
        @source_cdx_dir = "#{cdx_working_directory}/#{druid_id}/"
        @working_merged_cdx = "#{cdx_working_directory}/#{druid_id}_merged_index.cdx"
        @working_sorted_duplicate_cdx = "#{cdx_working_directory}/#{druid_id}_sorted_duplicate_index.cdx"
        @working_sorted_cdx = "#{cdx_working_directory}/#{druid_id}_sorted_index.cdx"
        @cdx_backup_directory = cdx_backup_directory
      end

      def sort_druid_cdx
        # merge and sort files from working_directory/druid_id/*.cdx to working_directory/[druid_id]_merged_index.cdx
        merge_cmd_string = "#{Dor::Config.was_crawl_dissemination.sort_env_vars} sort #{@source_cdx_dir}*.cdx > #{@working_merged_cdx}"
        Dor::WASCrawl::Dissemination::Utilities.run_sys_cmd(merge_cmd_string, "sorting #{@druid_id} CDX files and merging into single file")
      end

      def merge_with_main_index
        # merge and sort file from working_directory/[druid_id]_merged_index.cdx with cdx/index.cdx
        sort_cmd_string = "#{Dor::Config.was_crawl_dissemination.sort_env_vars} sort -u -m #{@working_merged_cdx} #{@main_cdx_file} > #{@working_sorted_cdx}"
        Dor::WASCrawl::Dissemination::Utilities.run_sys_cmd(sort_cmd_string, "merging #{@druid_id} CDX files with the main index")
      end

      def publish
        FileUtils.mv( @working_sorted_cdx, @main_cdx_file)
      end

      def clean
        FileUtils.mv(@source_cdx_dir, @cdx_backup_directory)
        FileUtils.rm(@working_sorted_duplicate_cdx) if File.exist?(@working_sorted_duplicate_cdx)
        FileUtils.rm(@working_merged_cdx) if File.exist?(@working_merged_cdx)
      end
    end
  end
end
