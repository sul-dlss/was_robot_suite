require 'spec_helper'
require 'content_metadata_generator_service'

describe Dor::WASSeed::ContentMetadataGenerator do

  describe ".create_thumbnail_xml_element" do
    it "should" do
      thumbnail_file = "/Users/aalsum/Desktop/workspace/ff/098/xp/7185/ff098xp7185/content/thumbnail.jpeg"
      cm_generator = Dor::WASSeed::ContentMetadataGenerator.new( "","") 
      puts cm_generator.create_thumbnail_xml_element thumbnail_file
       
    end

  end 

  describe ".generate_xml_doc" do
    it "should" do
#      thumbnail_file = "#{workspace}ff/098/xp/7185/ff098xp7185/content/thumbnail.jpeg"
      workspace = "/Users/aalsum/Desktop/workspace/"
      
      druid = "druid:ff098xp7185"
      cm_generator = Dor::WASSeed::ContentMetadataGenerator.new( workspace, druid) 
      puts cm_generator.generate_metadata_output
       
    end

  end 
  
 
end
