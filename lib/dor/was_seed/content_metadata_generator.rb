# frozen_string_literal: true

require 'digest/md5'
require 'digest/sha1'

module Dor
  module WasSeed
    class ContentMetadataGenerator < MetadataGenerator
      CONTENT_METADATA = 'contentMetadata'

      def generate_metadata_output
        ng_xml_for_thumbnail = ng_doc(create_thumbnail_xml_element("#{DruidTools::Druid.new(@druid_id, workspace).content_dir}/thumbnail.jp2"))
        metadata_content = transform_xml_using_xslt(ng_xml_for_thumbnail, read_template(CONTENT_METADATA))
        metadata_content = do_post_transform(metadata_content)
        write_file_to_druid_metadata_folder(CONTENT_METADATA, metadata_content)
      end

      private

      def ng_doc(image_xml_str = '')
        xml = "<?xml version=\"1.0\"?><item><druid>#{@druid_id}</druid>#{image_xml_str}</item>"
        Nokogiri::XML(xml)
      end

      def create_thumbnail_xml_element(thumbnail_file)
        unless !thumbnail_file.nil? && File.exist?(thumbnail_file)
          LyberCore::Log.warn "ThumbnailGenerator - #{thumbnail_file} doesn't exist"
          return ''
        end

        exif = MiniExiftool.new thumbnail_file
        if exif.MIMEType.nil? || exif.MIMEType != 'image/jp2'
          LyberCore::Log.warn "ThumbnailGenerator - #{thumbnail_file} is not a valid JP2 image"
          raise "#{thumbnail_file} is not a valid image"
        end

        begin
          thumbnail_file_object = File.new(thumbnail_file, 'r')
          thumbnail_file_data = thumbnail_file_object.read
        rescue StandardError => e
          LyberCore::Log.warn "ThumbnailGenerator - problem in reading #{thumbnail_file}"
          raise "Problem in reading #{thumbnail_file}. #{e.message}\n#{e.backtrace.inspect}"
        end

        size = thumbnail_file_object.size()
        if size == 0
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
