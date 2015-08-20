require 'spec_helper'
require 'thumbnail_generator_service'
RSpec.configure do |c|
  c.filter_run_excluding :image_prerequisite
end

describe Dor::WASSeed::ThumbnailGeneratorService do
  VCR.configure do |config|
    config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
    config.hook_into :webmock # or :fakeweb
  end
  
  RSpec.configure do |c|
    c.filter_run_excluding :image_prerequisite
  end
  
  before :all do
    Dor::Config.was_seed.wayback_uri = "https//swap.stanford.edu"
  end
  
  describe ".capture_thumbnail" do
    before :each do
      @druid_id = 'druid:ab123cd4567'
      @workspace = "spec/fixtures/workspace/"
      @uri = "http://www.slac.stanford.edu"
      FileUtils.cp "spec/fixtures/thumbnail_files/ab123cd4567.jpeg", "tmp/ab123cd4567.jpeg"
    end
    
    it "generates jp2 from jpeg thumbnail and pushes to druid_tree content directory", :image_prerequisite do
      allow(Dor::WASSeed::ThumbnailGeneratorService).to receive(:capture).and_return("")  
      Dor::WASSeed::ThumbnailGeneratorService.capture_thumbnail( @druid_id, @workspace, @uri)
      expect(File.exist?("spec/fixtures/workspace/ab/123/cd/4567/ab123cd4567/content/thumbnail.jp2")).to be true
      expect(File.exist?("tmp/ab123cd4567.jpeg" )).to be false
    end

    it "raises an error if there is an error in the capture method" do
      allow(Dor::WASSeed::ThumbnailGeneratorService).to receive(:capture).and_return('#FAIL#')  
      expect{Dor::WASSeed::ThumbnailGeneratorService.capture_thumbnail( @druid_id, @workspace, @uri)}.to raise_error.with_message("Thumbnail for druid druid:ab123cd4567 and http://www.slac.stanford.edu can't be generated.\n #FAIL#")
      expect(File.exist?("spec/fixtures/workspace/ab/123/cd/4567/ab123cd4567/content/thumbnail.jp2")).to be false
      expect(File.exist?("tmp/ab123cd4567.jpeg" )).to be false
    end    

    it "raises an error if there capture method raise an exception" do
      allow(Dor::WASSeed::ThumbnailGeneratorService).to receive(:capture).and_raise("Error")  
      expect{Dor::WASSeed::ThumbnailGeneratorService.capture_thumbnail( @druid_id, @workspace, @uri)}.to raise_error.with_message("Thumbnail for druid druid:ab123cd4567 and http://www.slac.stanford.edu can't be generated.\n Error")
      expect(File.exist?("spec/fixtures/workspace/ab/123/cd/4567/ab123cd4567/content/thumbnail.jp2")).to be false
      expect(File.exist?("tmp/ab123cd4567.jpeg" )).to be false
    end    

    after :each do
      FileUtils.rm_rf "spec/fixtures/workspace/ab" if File.exists?("spec/fixtures/workspace/ab")
      FileUtils.rm "tmp/ab123cd4567.jpeg" if File.exists?("tmp/ab123cd4567.jpeg")
    end
  end 
  
  describe ".capture" do
    pending
    it "captures jpeg image for the first capture of url", :image_prerequisite do
      VCR.use_cassette("slac_capture") do
        wayback_uri ="https://swap.stanford.edu/20110202032021/http://www.slac.stanford.edu"
        temporary_file = "tmp/test_capture.jpeg"
        result = Dor::WASSeed::ThumbnailGeneratorService.capture(wayback_uri,temporary_file)
        expect(result).to eq("")
      end     
    end
    after :each do 
      FileUtils.rm_rf "tmp/test_capture.jpeg" if File.exists?("tmp/test_capture.jpeg")
    end
  end
  
  describe ".resize_temporary_image", :image_prerequisite do
    it "resizes the image with extra width to maximum 400 pixel width" do
      temporary_image = "tmp/thum_extra_width.jpeg"
      FileUtils.cp "spec/fixtures/thumbnail_files/image_extra_width.jpeg",temporary_image
      Dor::WASSeed::ThumbnailGeneratorService.resize_temporary_image temporary_image
      expect(FileUtils.compare_file(temporary_image, "spec/fixtures/thumbnail_files/thum_extra_width.jpeg")).to be_truthy
    end
    it "resizes the image with extra height to maximum 400 pixel height", :image_prerequisite do
      temporary_image = "tmp/thum_extra_height.jpeg"
      FileUtils.cp "spec/fixtures/thumbnail_files/image_extra_height.jpeg", temporary_image
      Dor::WASSeed::ThumbnailGeneratorService.resize_temporary_image temporary_image
      expect(FileUtils.compare_file(temporary_image, "spec/fixtures/thumbnail_files/thum_extra_height.jpeg")).to be_truthy
    end

    after :each do 
      FileUtils.rm_rf "tmp/thum_extra_width.jpeg" if File.exists?("tmp/thum_extra_width.jpeg")
      FileUtils.rm "tmp/thum_extra_height.jpeg" if File.exists?("tmp/thum_extra_height.jpeg")
    end
  end
end
