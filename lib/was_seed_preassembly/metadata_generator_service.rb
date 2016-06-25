require 'nokogiri'

module Dor
  module WASSeed
    class MetadataGenerator
      attr_accessor :workspace
      attr_accessor :druid_id

      def initialize(workspace, druid_id)
        @workspace = workspace
        @druid_id = druid_id
        @extracted_metadata_xml_location = 'tmp/'
      end

      def read_metadata_xml_input_file
        druid_tree_directory = DruidTools::Druid.new(@druid_id, @workspace)
        metadata_xml_input = Nokogiri::XML(File.read("#{druid_tree_directory.content_dir}/source.xml"))
        unless metadata_xml_input.errors.empty?
          fail "#{druid_tree_directory.content_dir}/source.xml is not a valid xml file.\nNokogiri errors: #{metadata_xml_input.errors}"
        end
        metadata_xml_input
      end

      def write_file_to_druid_metadata_folder(metadata_file_name, metadata_content)
        druid_pathname = Pathname(DruidTools::Druid.new(@druid_id, @workspace.to_s).path).to_s
        fail "Directory for #{@druid_id} doesn't exist in workspace #{@workspace}" unless File.exist?(druid_pathname)
        metadata_pathname = druid_pathname + '/metadata/'
        Dir.mkdir(metadata_pathname) unless File.exist?(metadata_pathname)
        f = File.open(metadata_pathname + metadata_file_name + '.xml', 'w')
        f.write(metadata_content)
        f.close
      end

      def read_template(metadata_name)
        metadata_xslt_template = File.read(Pathname(File.dirname(__FILE__)).join("../../template/wasSeedPreassembly/#{metadata_name}.xslt"))
        metadata_xslt_template
      end

      def transform_xml_using_xslt(metadata_xml_input_object, metadata_xslt_template)
        metadata_xslt_template_object = Nokogiri::XSLT(metadata_xslt_template)
        metadata_content = metadata_xslt_template_object.transform(metadata_xml_input_object)
        metadata_content.to_s
      end

      def do_post_transform(metadata_content)
        metadata_content
      end
    end
  end
end
