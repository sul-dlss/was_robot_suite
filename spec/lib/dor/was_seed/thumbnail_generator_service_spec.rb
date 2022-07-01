require 'spec_helper'

RSpec.describe Dor::WasSeed::ThumbnailGeneratorService do
  before do
    Settings.was_seed.wayback_uri = 'https//swap.stanford.edu'
  end

  describe '.capture_thumbnail' do
    before do
      @druid_id = 'druid:ab123cd4567'
      @workspace = 'spec/was_seed_preassembly/fixtures/workspace/'
      @uri = 'http://www.slac.stanford.edu'
      FileUtils.rm 'tmp/ab123cd4567.jp2', force: true
      FileUtils.cp 'spec/was_seed_preassembly/fixtures/thumbnail_files/ab123cd4567.jpeg', 'tmp/ab123cd4567.jpeg'
    end

    after do
      FileUtils.rm_rf 'spec/was_seed_preassembly/fixtures/workspace/ab'
      FileUtils.rm 'tmp/ab123cd4567.jpeg', force: true
      FileUtils.rm 'tmp/ab123cd4567.jp2', force: true
    end

    it 'generates jp2 from jpeg thumbnail and pushes to druid_tree content directory', :image_prerequisite do
      allow(described_class).to receive(:screenshot).and_call_original
      described_class.capture_thumbnail(@druid_id, @workspace, @uri)
      expect(File.exist?('spec/was_seed_preassembly/fixtures/workspace/ab/123/cd/4567/ab123cd4567/content/thumbnail.jp2')).to be true
      expect(File.exist?('tmp/ab123cd4567.jpeg')).to be false
    end

    it 'raises an error if the screenshot method raises an exception' do
      allow(described_class).to receive(:screenshot).and_raise('Foo')
      exp_msg = "Thumbnail for druid druid:ab123cd4567 and http://www.slac.stanford.edu can't be generated.\n Foo"
      expect { described_class.capture_thumbnail(@druid_id, @workspace, @uri) }.to raise_error.with_message(exp_msg)
      expect(File.exist?('spec/was_seed_preassembly/fixtures/workspace/ab/123/cd/4567/ab123cd4567/content/thumbnail.jp2')).to be false
      expect(File.exist?('tmp/ab123cd4567.jpeg')).to be false
    end
  end

  describe '.screenshot' do
    before do
      FileUtils.rm 'tmp/test_capture.jpeg', force: true
    end

    after do
      FileUtils.rm 'tmp/test_capture.jpeg', force: true
    end

    it 'captures jpeg image for the first capture of url', :image_prerequisite do
      pending 'fails from jquery error'
      VCR.use_cassette('slac_capture') do
        wayback_uri = 'https://swap.stanford.edu/20110202032021/http://www.slac.stanford.edu'
        temporary_file = 'tmp/test_capture'
        result = described_class.screenshot(wayback_uri, temporary_file)
        expect(result).to eq('')
      end
    end
  end

  describe '.resize_jpeg', :image_prerequisite do
    after do
      FileUtils.rm 'tmp/thum_extra_width.jpeg', force: true
      FileUtils.rm 'tmp/thum_extra_height.jpeg', force: true
    end

    it 'resizes the image with extra width to maximum 400 pixel width' do
      temporary_image = 'tmp/thum_extra_width.jpeg'
      FileUtils.cp 'spec/was_seed_preassembly/fixtures/thumbnail_files/image_extra_width.jpeg', temporary_image
      described_class.resize_jpeg temporary_image
      expect(FileUtils.compare_file(temporary_image, 'spec/fixtures/thumbnail_files/thum_extra_width.jpeg')).to be_truthy
    end

    it 'resizes the image with extra height to maximum 400 pixel height', :image_prerequisite do
      temporary_image = 'tmp/thum_extra_height.jpeg'
      FileUtils.cp 'spec/was_seed_preassembly/fixtures/thumbnail_files/image_extra_height.jpeg', temporary_image
      described_class.resize_jpeg temporary_image
      expect(FileUtils.compare_file(temporary_image, 'spec/was_seed_preassembly/fixtures/thumbnail_files/thum_extra_height.jpeg')).to be_truthy
    end
  end

  describe '.indexed?' do
    let(:uri) { 'http://www.slac.stanford.edu' }

    context 'when the uri is found in the cdxj index' do
      let(:response_body) { { body: 'some content' } }
      let(:response) { Net::HTTPSuccess.new(1.0, '200', 'OK') }

      it 'returns nil when the uri is found in the index' do
        allow(Net::HTTP).to receive(:get_response).and_return(response)
        allow(response).to receive(:body).and_return(response_body)
        expect(described_class.indexed?(uri)).to be_nil
      end
    end

    context 'when the uri is not found in the cdxj index' do
      let(:response) { Net::HTTPSuccess.new(1.0, '200', 'OK') }

      it 'returns nil when the uri is found in the index' do
        allow(Net::HTTP).to receive(:get_response).and_return(response)
        allow(response).to receive(:body).and_return(nil)
        expect { described_class.indexed?(uri) }.to raise_error.with_message("#{uri} not found in cdxj index.")
      end
    end
  end
end
