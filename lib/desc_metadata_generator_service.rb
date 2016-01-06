require 'metadata_generator_service'

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

      write_file_to_druid_metadata_folder( @desc_metadata_name, metadata_content)
    end

    def generate_xml_doc
      item = Dor::Item.find(@druid_id)
      identityMetadata = item.datastreams['identityMetadata']
      title_list = identityMetadata.objectLabel
      unless title_list.nil? && title_list.empty? then
        xml_input = "<?xml version=\"1.0\"?><title>#{title_list[0]}</title>"
        return xml_input
      else
        raise "#{@druid_id} identityMetadata doesn't have a valid objectLabel"
      end
    end
   end
  end
end
