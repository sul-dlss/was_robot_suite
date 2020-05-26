require 'spec_helper'
require 'was_seed_preassembly/thumbnail_generator_service'

describe Dor::WASSeed::ThumbnailGeneratorService do
  # VCR.configure do |config|
  #   config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  #   config.hook_into :webmock # or :fakeweb
  # end

  before :all do
    Settings.was_seed.wayback_uri = 'https//swap.stanford.edu'
  end

  describe '.capture_thumbnail' do
    before :each do
      @druid_id = 'druid:ab123cd4567'
      @workspace = 'spec/was_seed_preassembly/fixtures/workspace/'
      @uri = 'http://www.slac.stanford.edu'
      FileUtils.rm 'tmp/ab123cd4567.jp2', force: true
      FileUtils.cp 'spec/was_seed_preassembly/fixtures/thumbnail_files/ab123cd4567.jpeg', 'tmp/ab123cd4567.jpeg'
    end

    it 'generates jp2 from jpeg thumbnail and pushes to druid_tree content directory', :image_prerequisite do
      allow(Dor::WASSeed::ThumbnailGeneratorService).to receive(:capture).and_return('')
      Dor::WASSeed::ThumbnailGeneratorService.capture_thumbnail(@druid_id, @workspace, @uri)
      expect(File.exist?('spec/was_seed_preassembly/fixtures/workspace/ab/123/cd/4567/ab123cd4567/content/thumbnail.jp2')).to be true
      expect(File.exist?('tmp/ab123cd4567.jpeg')).to be false
    end

    it 'raises an error if there is an error in the capture method' do
      allow(Dor::WASSeed::ThumbnailGeneratorService).to receive(:capture).and_return('#FAIL#')
      exp_msg = "Thumbnail for druid druid:ab123cd4567 and http://www.slac.stanford.edu can't be generated.\n #FAIL#"
      expect { Dor::WASSeed::ThumbnailGeneratorService.capture_thumbnail(@druid_id, @workspace, @uri) }.to raise_error.with_message(exp_msg)
      expect(File.exist?('spec/was_seed_preassembly/fixtures/workspace/ab/123/cd/4567/ab123cd4567/content/thumbnail.jp2')).to be false
      expect(File.exist?('tmp/ab123cd4567.jpeg')).to be false
    end

    it 'raises an error if there capture method raise an exception' do
      allow(Dor::WASSeed::ThumbnailGeneratorService).to receive(:capture).and_raise('Error')
      exp_msg = "Thumbnail for druid druid:ab123cd4567 and http://www.slac.stanford.edu can't be generated.\n Error"
      expect { Dor::WASSeed::ThumbnailGeneratorService.capture_thumbnail(@druid_id, @workspace, @uri) }.to raise_error.with_message(exp_msg)
      expect(File.exist?('spec/was_seed_preassembly/fixtures/workspace/ab/123/cd/4567/ab123cd4567/content/thumbnail.jp2')).to be false
      expect(File.exist?('tmp/ab123cd4567.jpeg')).to be false
    end

    after :each do
      FileUtils.rm_rf 'spec/was_seed_preassembly/fixtures/workspace/ab' if File.exist?('spec/was_seed_preassembly/fixtures/workspace/ab')
      FileUtils.rm 'tmp/ab123cd4567.jpeg', force: true
      FileUtils.rm 'tmp/ab123cd4567.jp2', force: true
    end
  end

  describe '.capture' do
    before :each do
      FileUtils.rm 'tmp/test_capture.jpeg', force: true
    end
    it 'captures jpeg image for the first capture of url', :image_prerequisite do
      pending 'fails from jquery error'
      VCR.use_cassette('slac_capture') do
        wayback_uri = 'https://swap.stanford.edu/20110202032021/http://www.slac.stanford.edu'
        temporary_file = 'tmp/test_capture'
        result = Dor::WASSeed::ThumbnailGeneratorService.capture(wayback_uri, temporary_file)
        expect(result).to eq('')
      end
    end
    after :each do
      FileUtils.rm 'tmp/test_capture.jpeg', force: true
    end
  end

  describe '.resize_temporary_image', :image_prerequisite do
    it 'resizes the image with extra width to maximum 400 pixel width' do
      temporary_image = 'tmp/thum_extra_width.jpeg'
      FileUtils.cp 'spec/was_seed_preassembly/fixtures/thumbnail_files/image_extra_width.jpeg', temporary_image
      Dor::WASSeed::ThumbnailGeneratorService.resize_temporary_image temporary_image
      expect(FileUtils.compare_file(temporary_image, 'spec/fixtures/thumbnail_files/thum_extra_width.jpeg')).to be_truthy
    end
    it 'resizes the image with extra height to maximum 400 pixel height', :image_prerequisite do
      temporary_image = 'tmp/thum_extra_height.jpeg'
      FileUtils.cp 'spec/was_seed_preassembly/fixtures/thumbnail_files/image_extra_height.jpeg', temporary_image
      Dor::WASSeed::ThumbnailGeneratorService.resize_temporary_image temporary_image
      expect(FileUtils.compare_file(temporary_image, 'spec/was_seed_preassembly/fixtures/thumbnail_files/thum_extra_height.jpeg')).to be_truthy
    end

    after :each do
      FileUtils.rm 'tmp/thum_extra_width.jpeg', force: true
      FileUtils.rm 'tmp/thum_extra_height.jpeg', force: true
    end
  end
end
