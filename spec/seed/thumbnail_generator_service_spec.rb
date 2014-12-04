require 'spec_helper'
require 'thumbnail_generator_service'

describe Dor::WASSeed::ThumbnailGenerator do

  describe ".capture_thumbnail" do
    it "should generate technicalMetadata with valid input" do
      druid_id = 'druid:ff098xp7185'
      workspace = "/Users/aalsum/Desktop/workspace/"
      
      Dor::WASSeed::ThumbnailGenerator.capture_thumbnail( druid_id, workspace, "http://urbanstudies.stanford.edu/")
      
    end

  end 
  
  describe ".capture_thumbnail" do
    it "should" do
      
    end
  end
 
 
end
