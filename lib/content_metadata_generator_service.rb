require 'metadata_generator_service'
require 'digest/md5'
require 'digest/sha1'

module Dor
  module WASSeed
    class ContentMetadataGenerator < MetadataGenerator
      def initialize(workspace, druid_id)
        super(workspace, druid_id)
        @content_metadata_name = 'contentMetadata'
      end

      def generate_metadata_output
        xml_input = generate_xml_doc(create_thumbnail_xml_element "#{DruidTools::Druid.new(@druid_id, workspace).content_dir}/thumbnail.jp2")
        metadata_content = transform_xml_using_xslt(xml_input, read_template(@content_metadata_name))
        metadata_content = do_post_transform(metadata_content)
        write_file_to_druid_metadata_folder(@content_metadata_name, metadata_content)
      end

      def generate_xml_doc(image_xml_str = '')
        xml_input = "<?xml version=\"1.0\"?><item><druid>#{@druid_id}</druid>#{image_xml_str}</item>"
        Nokogiri::XML(xml_input)
      end

      def create_thumbnail_xml_element(thumbnail_file)
        unless !thumbnail_file.nil? && File.exist?(thumbnail_file) then
          LyberCore::Log.warn "ThumbnailGenerator - #{thumbnail_file} doesn't exist"
          return ''
        end

        exif = MiniExiftool.new thumbnail_file
        if exif.MIMEType.nil? || exif.MIMEType != 'image/jp2' then
          LyberCore::Log.warn "ThumbnailGenerator - #{thumbnail_file} is not a valid JP2 image"
          raise "#{thumbnail_file} is not a valid image"
        end

        begin
          thumbnail_file_object = File.new(thumbnail_file, 'r')
          thumbnail_file_data = thumbnail_file_object.read
        rescue Exception => e
          LyberCore::Log.warn "ThumbnailGenerator - problem in reading #{thumbnail_file}"
          raise "Problem in reading #{thumbnail_file}. #{e.message}\n#{e.backtrace.inspect}"
        end

        size = thumbnail_file_object.size()
        if size == 0 then
          LyberCore::Log.warn "ThumbnailGenerator - #{thumbnail_file} size is 0"
          return ''
        end

        md5 = Digest::MD5.hexdigest(thumbnail_file_data)
        sha1 = Digest::SHA1.hexdigest(thumbnail_file_data)
        width = exif.imagewidth
        height = exif.imageheight
        "<image><md5>#{md5}</md5><sha1>#{sha1}</sha1><size>#{size}</size><width>#{width}</width><height>#{height}</height></image>"
      end
    end
  end
end
