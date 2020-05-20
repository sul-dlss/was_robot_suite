module Dor
  module WASCrawl
    class CDXGeneratorService
      def initialize(collection_path, druid_id, contentMetadata)
        @contentMetadata = contentMetadata
        @druid_id = druid_id
        @collection_path = collection_path
        @cdx_indexer_script_file_name = Settings.was_crawl_dissemination.cdx_indexer_script
        @cdx_working_directory        = Settings.was_crawl_dissemination.cdx_working_directory
        @java_heap_size               = Settings.was_crawl_dissemination.java_heap_size
        @cdx_indexer_log_file = 'log/cdx_indexer.log'
      end

      def generate_cdx_for_crawl
        warc_file_list = Dor::WASCrawl::Dissemination::Utilities.get_warc_file_list_from_content_metadata(@contentMetadata)
        cdx_druid_dir = "#{@cdx_working_directory}/#{@druid_id}"
        FileUtils.makedirs cdx_druid_dir unless File.exist?(cdx_druid_dir)
        druid_base_directory = DruidTools::AccessDruid.new(@druid_id, @collection_path).path
        warc_file_list.each do |warc_file_name|
          cdx_file_name  = get_cdx_file_name(warc_file_name)
          cdx_file_path  = "#{cdx_druid_dir}/#{cdx_file_name}"
          warc_file_path = "#{druid_base_directory}/#{warc_file_name}"
          generate_cdx_for_one_warc(warc_file_path, cdx_file_path)
        end
      end

      def get_cdx_file_name(warc_file_name)
        cdx_file_name = File.basename(warc_file_name)
        if cdx_file_name.end_with? 'gz'
          cdx_file_name = cdx_file_name[0...-3]
        end
        if cdx_file_name.end_with? '.arc'
          cdx_file_name = cdx_file_name[0...-4]
        elsif cdx_file_name.end_with? '.warc'
          cdx_file_name = cdx_file_name[0...-5]
        end
        cdx_file_name + '.cdx'
      end

      def generate_cdx_for_one_warc(warc_file_path, cdx_file_path)
        cmd_string = prepare_cdx_generation_cmd_string(warc_file_path, cdx_file_path)
        Dor::WASCrawl::Dissemination::Utilities.run_sys_cmd(cmd_string, 'extracting CDX')
      end

      def prepare_cdx_generation_cmd_string(warc_file_path, cdx_file_path)
        raise 'invalid warc file name' if warc_file_path.nil? || warc_file_path.length < 1
        raise 'invalid cdx file name'  if cdx_file_path.nil?  || cdx_file_path.length < 1

        cmd_string = "#{@cdx_indexer_script_file_name} #{warc_file_path} #{cdx_file_path} 2>> #{@cdx_indexer_log_file}"
        cmd_string
      end
    end
  end
end
