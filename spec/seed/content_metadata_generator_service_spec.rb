require 'spec_helper'
require 'content_metadata_generator_service'
require 'equivalent-xml'

describe Dor::WASSeed::ContentMetadataGenerator do

  before(:all) do
    @staging_path = Pathname(File.dirname(__FILE__)).join("../../fixtures/")
    @expected_thumbnal_xml_element = "<image><md5>c8b96cc873ecc9805971b84f6c37ba3d</md5><sha1>87a27e146dd4e543d0be1aea6773253639ee19ff</sha1><size>249759</size><width>1000</width><height>1462</height></image>"
    @expected_full_xml_element = Nokogiri::XML("<?xml version='1.0'?><item><druid>druid:aa111aa1111</druid>#{@expected_thumbnal_xml_element}</item>")
    @expected_empty_xml_element = Nokogiri::XML("<?xml version='1.0'?><item><druid>druid:aa111aa1111</druid></item>")
  end


  describe ".generate_metadata_output" do
    it "should generate contentMetadata file for a valid druid and valid thumbnail"
  end

  describe ".generate_xml_doc" do
    it "should return a complete xml element for valid druid and an image xml element" do
      actual_xml_element =  cm_generator_instance_with_druid().generate_xml_doc @expected_thumbnal_xml_element
      expect(actual_xml_element.to_xml).to eq(@expected_full_xml_element.to_xml)
      #expect(actual_xml_element).to be_equivalent_to(@expected_xml_element)
    end
    
    it "should return a basic xml element for a valid druid and empty xml element" do
      actual_xml_element =  cm_generator_instance_with_druid().generate_xml_doc ""
      expect(actual_xml_element.to_xml).to eq(@expected_empty_xml_element.to_xml)
    end
    
    it "should return a basic xml element for a valid druid and empty xml element" do
      actual_xml_element =  cm_generator_instance_with_druid().generate_xml_doc 
      expect(actual_xml_element.to_xml).to eq(@expected_empty_xml_element.to_xml)
    end
  end 
  
  describe ".create_thumbnail_xml_element" do
    it "should return valid xml element for a regular image" do
      thumbnail_file_location = "#{@staging_path}/thumbnail_files/thumbnail1.jpeg"
      actual_xml_element = cm_generator_instance.create_thumbnail_xml_element thumbnail_file_location
      
      expect(actual_xml_element).to eq(@expected_thumbnal_xml_element)
      #expected_xml_objet = Nokogiri::XML(@expected_thumbnal_xml_element)
      #actual_xml_object  = Nokogiri::XML(actual_xml_element)
     # expect(actual_xml_object).to be_equivalent_to(expected_xml_objet)
    end
    
    it "should return empty string for non-existing images" do
      thumbnail_file_location = "#{@staging_path}/thumbnail_files/nonthing.jpeg"
      actual_xml_element = cm_generator_instance().create_thumbnail_xml_element thumbnail_file_location
      expect(actual_xml_element).to eq("")
    end

    it "should return empty string for null location string" do
      actual_xml_element = cm_generator_instance().create_thumbnail_xml_element nil
      expect(actual_xml_element).to eq("")      
    end
    
    it "should raise an excetion for reading an empty image" do
      # This test case should be fixed with adding an empty image
       thumbnail_file_location = "#{@staging_path}/thumbnail_files/thumbnail_empty.jpeg"
       expect{ create_thumbnail_xml_element thumbnail_file_location }.to raise_error   
    end

    it "should raise an error for reading an invalid image" do
       thumbnail_file_location = "#{@staging_path}/thumbnail_files/thumbnail_text.jpeg"
       expect{ create_thumbnail_xml_element thumbnail_file_location }.to raise_error   
    end

  end
  
  def cm_generator_instance
    return Dor::WASSeed::ContentMetadataGenerator.new( "", "")
  end
  
  def cm_generator_instance_with_druid druid="druid:aa111aa1111"
    return Dor::WASSeed::ContentMetadataGenerator.new( "", druid) 
  end
 
end
