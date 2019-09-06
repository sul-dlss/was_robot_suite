require 'was_seed_preassembly/metadata_generator_service'

module Dor
  module WASSeed
    class DescMetadataGenerator < MetadataGenerator
      attr_reader :desc_metadata_name, :seed_uri, :collection_id

      def initialize(workspace_path, druid_id, seed_uri, collection_id)
        super(workspace_path, druid_id)
        @desc_metadata_name = 'descMetadata'
        @seed_uri = seed_uri
        @collection_id = collection_id
      end

      def generate_metadata_output
        xslt_template = read_template(desc_metadata_name)
        metadata_content = transform_xml_using_xslt(xml_input, xslt_template)
        metadata_content = do_post_transform(metadata_content)
        write_file_to_druid_metadata_folder(desc_metadata_name, metadata_content)
      end

      def xml_input
        source_xml = <<-XML
              <item>
                <collection_id>#{collection_id}</collection_id>
                <uri>#{seed_uri}</uri>
              </item>
        XML
        Nokogiri::XML(source_xml)
      end
    end
  end
end
