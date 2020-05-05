require 'was_crawl_preassembly/metadata_generator_service'

module Dor
  module WASCrawl
    class DescMetadataGenerator < MetadataGenerator
      def initialize(collection_id, staging_path, druid_id)
        super(collection_id, staging_path, druid_id)
        @desc_metadata_name = 'descMetadata'
      end

      def generate_metadata_output
        xml_input = generate_xml_doc # generating basic xml instead of reading from the input file
        xslt_template = read_template(@desc_metadata_name)
        metadata_content = transform_xml_using_xslt(xml_input, xslt_template)
        metadata_content = do_post_transform(metadata_content)
        write_file_to_druid_metadata_folder(@desc_metadata_name, metadata_content)
      end

      def generate_xml_doc
        item = Dor::Services::Client.object(@druid_id).find
        "<?xml version=\"1.0\"?><title>#{item.label}</title>"
      end
    end
  end
end
