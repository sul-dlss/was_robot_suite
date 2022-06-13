module Dor
  module WasCrawl
    class CdxjMergeService
      def initialize(druid_id:)
        @druid_id = druid_id
      end

      def self.merge(druid_id:)
        new(druid_id: druid_id).merge
      end

      delegate :main_cdxj_file, :working_directory, :backup_directory, to: :config
      attr_reader :druid_id

      def source_dir
        "#{working_directory}/#{druid_id}/"
      end

      def working_sorted_index
        "#{working_directory}/#{druid_id}_sorted_index.cdxj"
      end

      def working_merged_index
        "#{working_directory}/#{druid_id}_merged_index.cdxj"
      end

      def config
        Settings.cdxj_indexer
      end

      def merge
        with_lock do
          if need_to_merge?
            sort_druid_cdx
            merge_with_main_index
            publish
          end
          clean
        end
      end

      def need_to_merge?
        Dir["#{working_directory}/#{druid_id}/*"].present?
      end

      # synchornize writes with other processes
      def with_lock(&block)
        Lockfile.new(lock_filename, &block)
      end

      def lock_filename
        main_cdxj_dir = File.dirname(main_cdxj_file)
        "#{main_cdxj_dir}/working.lock"
      end

      def sort_druid_cdx
        # merge and sort files from working_directory/druid_id/*.cdxj to working_directory/[druid_id]_merged_index.cdxj
        merge_cmd_string = "#{sort_env_vars} sort #{source_dir}*.cdxj > #{working_merged_index}"
        Dor::WasCrawl::Dissemination::Utilities.run_sys_cmd(merge_cmd_string, "sorting #{druid_id} CDXJ files and merging into single file")
      end

      def merge_with_main_index
        # merge file from working_directory/[druid_id]_merged_index.cdxj with cdxj/level0.cdxj
        # This depends on the input files being pre-sorted
        sort_cmd_string = "#{sort_env_vars} sort --unique --merge #{working_merged_index} #{main_cdxj_file} > #{working_sorted_index}"
        Dor::WasCrawl::Dissemination::Utilities.run_sys_cmd(sort_cmd_string, "merging #{druid_id} CDXJ files with the main index")
      end

      def publish
        FileUtils.mv(working_sorted_index, main_cdxj_file)
      end

      def clean
        FileUtils.mv(source_dir, backup_directory, force: true)
        FileUtils.rm(working_merged_index) if File.exist?(working_merged_index)
      end

      def sort_env_vars
        # See http://iipc.github.io/warc-specifications/specifications/cdx-format/openwayback-cdxj/#sorting-file--index
        "LC_ALL=C"
      end
    end
  end
end
