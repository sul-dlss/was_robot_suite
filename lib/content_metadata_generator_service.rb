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
      metadata_content = 
      thumbnail_file  = "#{DruidTools::Druid.new(@druid_id,workspace).content_dir}/thumbnail.jpeg"

      image_xml_str = create_thumbnail_xml_element thumbnail_file
      xml_input = generate_xml_doc image_xml_str #generating basic xml instead of reading from the input file
      
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
      unless File.exist?(thumbnail_file) then 
        return ""
      end
      
      thumbnail_file_object = File.new(thumbnail_file, "r")
      thumbnail_file_data = thumbnail_file_object.read()
      
      md5 = Digest::MD5.hexdigest(thumbnail_file_data)
      sha1 = Digest::SHA1.hexdigest(thumbnail_file_data)
      size = thumbnail_file_object.size()
      
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