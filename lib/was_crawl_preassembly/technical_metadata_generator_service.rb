require 'was_crawl_preassembly/metadata_generator_service'

module Dor
  module WASCrawl
    class TechnicalMetadataGenerator < MetadataGenerator
      def initialize(collection_id, staging_path, druid_id)
        super(collection_id, staging_path, druid_id)
        @technical_metadata_name = 'technicalMetadata'
      end

      def generate_metadata_output
        xml_input = read_metadata_xml_input_file
        xslt_template = read_template(@technical_metadata_name)
        metadata_content = transform_xml_using_xslt(xml_input, xslt_template)
        metadata_content = do_post_transform(metadata_content)
        write_file_to_druid_metadata_folder(@technical_metadata_name, metadata_content)
      end
    end
  end
end
