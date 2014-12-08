require 'metadata_generator_service'
require 'digest/md5'
require 'digest/sha1'
require 'fastimage'

module Dor
  module WASSeed
  
    class ContentMetadataGenerator < MetadataGenerator
    
    
    def initialize(workspace, druid_id)
      super(workspace, druid_id)
      @content_metadata_name = "contentMetadata"
    end
  
    def generate_metadata_output
      thumbnail_file  = "#{DruidTools::Druid.new(@druid_id,workspace).content_dir}/thumbnail.jpeg"
      image_xml_str = create_thumbnail_xml_element thumbnail_file

      xml_input = generate_xml_doc image_xml_str 
      
      xslt_template = read_template(@content_metadata_name)
      metadata_content = transform_xml_using_xslt(xml_input,xslt_template)
      metadata_content = do_post_transform(metadata_content)
      
      write_file_to_druid_metadata_folder( @content_metadata_name, metadata_content)
    end
    
    def generate_xml_doc image_xml_str=""
      xml_input="<?xml version=\"1.0\"?><item><druid>#{@druid_id}</druid>#{image_xml_str}</item>"
      return Nokogiri::XML(xml_input)
    end
      
    def create_thumbnail_xml_element thumbnail_file
      unless !thumbnail_file.nil? and File.exist?(thumbnail_file) then 
        LyberCore::Log.warn "ThumbnailGenerator - #{thumbnail_file} doesn't exist"
        return ""
      end
      
      if FastImage.type(thumbnail_file).nil? then
        LyberCore::Log.warn "ThumbnailGenerator - #{thumbnail_file} is not a valid image"
        raise "#{thumbnail_file} is not a valid image"
      end
      
      begin
        thumbnail_file_object = File.new(thumbnail_file, "r")
        thumbnail_file_data = thumbnail_file_object.read()
      rescue Exception => e
        LyberCore::Log.warn "ThumbnailGenerator - problem in reading #{thumbnail_file}"
        raise "Problem in reading #{thumbnail_file}. #{e.message}\n#{e.backtrace.inspect}"
      end

      size = thumbnail_file_object.size()
      if size == 0 then
        LyberCore::Log.warn "ThumbnailGenerator - #{thumbnail_file} size is 0"
        return ""
      end
              
      md5 = Digest::MD5.hexdigest(thumbnail_file_data)
      sha1 = Digest::SHA1.hexdigest(thumbnail_file_data)
      
 
      dimensions = FastImage.size(thumbnail_file)
      width = dimensions[0]
      height = dimensions[1]
 
      xml_str = "<image>"+
                "<md5>#{md5}</md5>"+
                "<sha1>#{sha1}</sha1>"+
                "<size>#{size}</size>"+
                "<width>#{width}</width>"+
                "<height>#{height}</height>"+
                "</image>"
      return xml_str
          
    end
   end 
  end
end