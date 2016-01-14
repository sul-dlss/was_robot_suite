require 'metadata_generator_service'

module Dor
  module WASSeed
    class DescMetadataGenerator < MetadataGenerator
    def initialize(workspace_path, druid_id)
      super( workspace_path, druid_id)
      @desc_metadata_name = 'descMetadata'
    end

    def generate_metadata_output

      xml_input = read_metadata_xml_input_file #generating basic xml instead of reading from the input file

      source = xml_input.xpath('//item/source').text
      xslt_template = read_template(@desc_metadata_name+"_#{source}")

      metadata_content = transform_xml_using_xslt(xml_input, xslt_template)
      metadata_content = do_post_transform(metadata_content)

      write_file_to_druid_metadata_folder( @desc_metadata_name, metadata_content)
    end
   end
  end
end
