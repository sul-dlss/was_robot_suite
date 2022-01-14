require 'nokogiri'

module Dor
  module WASSeed
    class MetadataGenerator
      attr_accessor :workspace, :druid_id

      def initialize(workspace, druid_id, _extracted_location = 'tmp/')
        @workspace = workspace
        @druid_id = druid_id
      end

      def read_metadata_xml_input_file
        druid_tree_directory = DruidTools::Druid.new(@druid_id, @workspace)
        metadata_xml_input = Nokogiri::XML(File.read("#{druid_tree_directory.content_dir}/source.xml"))
        raise "#{druid_tree_directory.content_dir}/source.xml is not a valid xml file.\nNokogiri errors: #{metadata_xml_input.errors}" unless metadata_xml_input.errors.empty?

        metadata_xml_input
      end

      def write_file_to_druid_metadata_folder(metadata_file_name, metadata_content)
        metadata_pathname = DruidTools::Druid.new(@druid_id, @workspace.to_s).metadata_dir
        f = File.open(File.join(metadata_pathname, "#{metadata_file_name}.xml"), 'w')
        f.write(metadata_content)
        f.close
      end

      def read_template(metadata_name)
        File.read(Pathname(File.dirname(__FILE__)).join("../../template/wasSeedPreassembly/#{metadata_name}.xslt"))
      end

      def transform_xml_using_xslt(metadata_xml_input_object, metadata_xslt_template)
        metadata_xslt_template_object = Nokogiri::XSLT(metadata_xslt_template)
        metadata_content = metadata_xslt_template_object.transform(metadata_xml_input_object)
        metadata_content.to_s
      end

      # NOP - returns what you pass in
      def do_post_transform(metadata_content)
        metadata_content
      end
    end
  end
end
