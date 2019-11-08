require 'pathname'
require 'druid-tools'

module Dor
  module WASCrawl
    class MetadataExtractor
      def initialize(collection_id, crawl_id, staging_path, druid_id)
        @collection_id = collection_id
        @crawl_id      = crawl_id
        @staging_path  = staging_path
        @druid_id      = druid_id
        @java_log_file = 'log/jar_WASMetadataExtractor.log'
        @extracted_metadata_xml_path = 'tmp'
        @java_heap_size = Settings.was_crawl.java_heap_size
      end

      def run_metadata_extractor_jar
        prepare_parameters
        java_cmd = build_cmd_string
        call_java_library(java_cmd)
      end

      def prepare_parameters
        @input_directory = Pathname(DruidTools::Druid.new(@druid_id, @staging_path.to_s).path).to_s + '/content'
        raise "#{@input_directory} doesn't exist" unless File.exist?(@input_directory)
        @jar_path = Settings.was_crawl.metadata_extractor_jar
        @xml_output_location = "#{@extracted_metadata_xml_path}/#{@druid_id}.xml"
      end

      def build_cmd_string
        "java #{@java_heap_size} -jar #{@jar_path} -f XML -d #{@input_directory} -o #{@xml_output_location} -c config/extractor.yml --collectionId #{@collection_id} --crawlId #{@crawl_id} 2>> #{@java_log_file}"
      end

      def call_java_library(java_cmd)
        raise 'Error in executing the WASMetadataExtractor.jar' + "\n" + $?.to_s unless system(java_cmd)
      end
    end
  end
end
