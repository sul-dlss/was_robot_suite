require 'English'
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
      end

      def run
        # This previously used WASMetadataExtractor.
        # However, it has now been simplified to create the necessary XML without it.
        prepare_parameters
        File.write(@xml_output_location, build_xml)
      end

      def prepare_parameters
        @input_directory = "#{Pathname(DruidTools::Druid.new(@druid_id, @staging_path.to_s).path)}/content"
        raise "#{@input_directory} doesn't exist" unless File.exist?(@input_directory)

        @xml_output_location = "tmp/#{@druid_id}.xml"
      end

      def build_xml
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.crawlObject do
            xml.crawlId @crawl_id
            xml.collectionId @collection_id
            xml.files do
              build_files(xml)
            end
          end
        end
        builder.to_xml
      end

      def build_files(xml)
        Dir.glob("*.warc.gz", base: @input_directory).each do |filename|
          filepath = "#{@input_directory}/#{filename}"
          xml.file do
            xml.name filename
            xml.type "WARC"
            xml.size File.size(filepath)
            xml.mimeType 'application/warc'
            xml.checksumMD5 Digest::MD5.file(filepath).hexdigest
            xml.checksumSHA1 Digest::SHA1.file(filepath).hexdigest
          end
        end
      end
    end
  end
end
