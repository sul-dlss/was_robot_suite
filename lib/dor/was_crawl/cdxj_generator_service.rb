module Dor
  module WasCrawl
    class CdxjGeneratorService
      def initialize(collection_path, druid_id)
        @druid_id = druid_id
        @collection_path = collection_path
      end

      def generate(warc_file_list)
        FileUtils.mkdir_p druid_dir
        warc_file_list.each do |warc_file_name|
          generate_cdx_for_one_warc(warc_file_name)
        end
      end

      private

      def druid_base_directory
        DruidTools::AccessDruid.new(@druid_id, @collection_path).path
      end

      def druid_dir
        @druid_dir ||= "#{Settings.cdxj_indexer.working_directory}/#{@druid_id}"
      end

      def cdx_file_name(warc_file_name)
        file_name = File.basename(warc_file_name, '.*')
        "#{druid_dir}/#{file_name}.cdxj"
      end

      def generate_cdx_for_one_warc(warc_file_name)
        cdx_file_path  = cdx_file_name(warc_file_name)
        warc_file_path = "#{druid_base_directory}/#{warc_file_name}"
        cmd_string = "#{Settings.cdxj_indexer.bin} #{warc_file_path} --output #{cdx_file_path} --post-append 2>> log/cdx_indexer.log"
        Dor::WasCrawl::Dissemination::Utilities.run_sys_cmd(cmd_string, 'extracting CDXJ')
      end
    end
  end
end
