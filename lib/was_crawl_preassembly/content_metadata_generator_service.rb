require 'was_crawl_preassembly/metadata_generator_service'

module Dor
  module WASCrawl
    class ContentMetadataGenerator < MetadataGenerator
      def initialize(collection_id, staging_path, druid_id)
        super(collection_id, staging_path, druid_id)
        @content_metadata_name = 'contentMetadata'
      end

      def generate_metadata_output
        xml_input = read_metadata_xml_input_file
        xslt_template = read_template("#{@content_metadata_name}_#{template_suffix}")
        metadata_content = transform_xml_using_xslt(xml_input, xslt_template)
        metadata_content = do_post_transform(metadata_content)
        write_file_to_druid_metadata_folder(@content_metadata_name, metadata_content)
      end

      # Add some attributes to make the contentMetadata compliant with all SDR contentMetadata
      def do_post_transform(metadata_content)
        # include druid_id in the xml before saving
        metadata_content_xml = Nokogiri::XML(metadata_content)
        unless metadata_content_xml.errors.empty?
          raise "The input string is not a valid xml file.\nNokogiri errors: #{metadata_content_xml.errors}\n#{metadata_content_xml}"
        end
        metadata_content_xml.root.set_attribute('id', @druid_id)
        resources = metadata_content_xml.root.xpath('resource')
        druid_without_namespace = @druid_id.sub(/^druid:/, '')
        resources.each.with_index(1) do |resource, i|
          resource.set_attribute('id', "#{druid_without_namespace}_#{i}")
        end
        metadata_content_xml.to_s
      end

      def template_suffix
        object_client = Dor::Services::Client.object(@druid_id)
        cocina_model = object_client.find
        apo = Dor::Services::Client.object(cocina_model.administrative.hasAdminPolicy).find
        default_rights_xml = apo.administrative.defaultObjectRights
        # If the read access is anything other than world, it's dark.
        Nokogiri::XML(default_rights_xml).xpath('//access[@type="read"]/machine/world').first.nil? ? 'dark' : 'public'
      end
    end
  end
end
