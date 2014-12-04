require 'spec_helper'
require 'desc_metadata_generator_service'

describe Dor::WASSeed::DescMetadataGenerator do

  describe ".generate_metadata_output" do
    it "should generate technicalMetadata with valid input" do
      druid_id = 'druid:ff098xp7185'
      workspace = "/Users/aalsum/Desktop/workspace/"
      
      
      metadata_generator_service = Dor::WASSeed::DescMetadataGenerator.new(workspace,druid_id)
      metadata_generator_service.generate_metadata_output
      
      expected_output_file = "#{workspace}/ff/098/xp/7185/ff098xp7185/metadata/descMetadata.xml"    
      actual_desc_metadata = File.read(expected_output_file)
      puts actual_desc_metadata
 #     actual_desc_metadata.should eq @expected_desc_metadata
    end

  end 
 
 
end
