# frozen_string_literal: true

require 'vips'
require 'stub_server'

RSpec.describe Dor::WasSeed::ThumbnailGeneratorService do
  describe '.capture_thumbnail' do
    let(:druid) { 'druid:ab123cd4567' }
    let(:workspace) { 'spec/was_seed_preassembly/fixtures/workspace/' }
    let(:uri) { 'http://www.slac.stanford.edu' }
    let(:screenshot_jpeg_file) { 'tmp/ab123cd4567.jpeg' }
    let(:thumbnail_jp2_file) { 'spec/was_seed_preassembly/fixtures/workspace/ab/123/cd/4567/ab123cd4567/content/thumbnail.jp2' }

    before do
      FileUtils.rm_f thumbnail_jp2_file
      # the following fakes the result of calling .screenshot by putting a file where a result is expected
      FileUtils.cp 'spec/was_seed_preassembly/fixtures/thumbnail_files/ab123cd4567.jpeg', screenshot_jpeg_file
    end

    after do
      FileUtils.rm_f thumbnail_jp2_file
      FileUtils.rm_rf 'spec/was_seed_preassembly/fixtures/workspace/ab'
      FileUtils.rm_f screenshot_jpeg_file
    end

    it 'generates max 400 px jp2 from jpeg screenshot and pushes to druid_tree content directory', js: true do
      allow(described_class).to receive(:screenshot) # NOTE: this does NOT execute screenshot, the FileUtils.cp in before mocks this
      described_class.capture_thumbnail(druid, workspace, uri)
      expect(File.exist?(screenshot_jpeg_file)).to be false # screenshot jpeg is removed - it's produced on the way to the jp2
      expect(File.exist?(thumbnail_jp2_file)).to be true
      # what follows is a poor attempt to indicate this is a true thumbnail for the given image.
      # MiniExiftool is used because getting a version of libvips that reads jp2 loaded on circleci ubuntu was too hard.
      thumbnail_image = MiniExiftool.new(thumbnail_jp2_file)
      expect(thumbnail_image.imagewidth).to eq 400
      expect(thumbnail_image.imageheight).to eq 400
    end

    it 'raises an error if the screenshot method raises an exception' do
      allow(described_class).to receive(:screenshot).and_raise('Foo')
      exp_msg = "Thumbnail for druid druid:ab123cd4567 and http://www.slac.stanford.edu can't be generated.\n Foo"
      expect { described_class.capture_thumbnail(druid, workspace, uri) }.to raise_error.with_message(exp_msg)
      expect(File.exist?(thumbnail_jp2_file)).to be false
      expect(File.exist?(screenshot_jpeg_file)).to be false
    end
  end

  describe '.screenshot' do
    let(:wayback_uri) { "http://localhost:#{port}/#{Dor::WasSeed::ThumbnailGeneratorService::DATE_TO_TRIGGER_EARLIEST_CAPTURE}/http://www.slac.stanford.edu" }
    let(:port) { 9123 }
    let(:replies) { { "/#{Dor::WasSeed::ThumbnailGeneratorService::DATE_TO_TRIGGER_EARLIEST_CAPTURE}/http://www.slac.stanford.edu" => [200, {}, ["<html><body>Hello World</body></html>"]] } }
    let(:screenshot_jpeg_file) { 'tmp/test_capture.jpeg' }

    before do
      allow(Settings).to receive(:chrome_path).and_return('/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome') if /darwin/.match(RUBY_PLATFORM)
    end

    after do
      FileUtils.rm screenshot_jpeg_file, force: true
    end

    it 'captures jpeg image for the first capture of url' do
      StubServer.open(port, replies) do |server|
        server.wait # ~ 0.1s
        described_class.screenshot(wayback_uri, screenshot_jpeg_file)
      end
      screenshot_image = Vips::Image.new_from_file(screenshot_jpeg_file)
      expect(screenshot_image.width).to eq 1200
      expect(screenshot_image.height).to eq 800
    end
  end

  describe '.resize_jpeg' do
    let(:resized_jpeg_file) { 'tmp/resized.jpeg' }

    after do
      FileUtils.rm_f 'tmp/resize_extra_width.jpeg'
      FileUtils.rm_f 'tmp/resize_extra_height.jpeg'
      FileUtils.rm_f resized_jpeg_file
    end

    it 'resizes the image with extra width to maximum 400 pixel width' do
      original_file = 'spec/was_seed_preassembly/fixtures/thumbnail_files/image_extra_width.jpeg'
      original_file_copy = 'tmp/resize_extra_width.jpeg'
      FileUtils.cp(original_file, original_file_copy)
      described_class.resize_jpeg(original_file_copy, resized_jpeg_file)

      # access: :sequential is faster to load than random (default), but less good for processing
      original_image = Vips::Image.new_from_file(original_file, access: :sequential)
      expected_thumb_image = Vips::Image.new_from_file('spec/was_seed_preassembly/fixtures/thumbnail_files/thum_extra_width.jpeg', access: :sequential)
      generated_thumb_jpeg = Vips::Image.new_from_file(resized_jpeg_file, access: :sequential)
      # what follows is a poor attempt to indicate this is a true thumbnail for the given image.
      expect(generated_thumb_jpeg.width).to be < original_image.width
      expect(generated_thumb_jpeg.height).to be < original_image.height
      expect(generated_thumb_jpeg.width).to eq 400
      expect(generated_thumb_jpeg.height).to eq 348
      expect(generated_thumb_jpeg.width).to eq expected_thumb_image.width
      expect(generated_thumb_jpeg.height).to eq expected_thumb_image.height
      # this comparison of the image content itself (by the pixel) courtesy of Tony Calavano
      expect((expected_thumb_image == generated_thumb_jpeg).min).to be < 255.0
    end

    it 'resizes the image with extra height to maximum 400 pixel height' do
      original_file = 'spec/was_seed_preassembly/fixtures/thumbnail_files/image_extra_height.jpeg'
      original_file_copy = 'tmp/resize_extra_height.jpeg'
      FileUtils.cp(original_file, original_file_copy)
      described_class.resize_jpeg(original_file_copy, resized_jpeg_file)

      # access: :sequential is faster to load than random (default), but less good for processing
      original_image = Vips::Image.new_from_file(original_file, access: :sequential)
      expected_thumb_image = Vips::Image.new_from_file('spec/was_seed_preassembly/fixtures/thumbnail_files/thum_extra_height.jpeg', access: :sequential)
      generated_thumb_jpeg = Vips::Image.new_from_file(resized_jpeg_file, access: :sequential)
      # what follows is a poor attempt to indicate this is a true thumbnail for the given image.
      expect(generated_thumb_jpeg.width).to be < original_image.width
      expect(generated_thumb_jpeg.height).to be < original_image.height
      expect(generated_thumb_jpeg.width).to eq 227
      expect(generated_thumb_jpeg.height).to eq 400
      expect(generated_thumb_jpeg.width).to eq expected_thumb_image.width
      expect(generated_thumb_jpeg.height).to eq expected_thumb_image.height
      # this comparison of the image content itself (by the pixel) courtesy of Tony Calavano
      expect((expected_thumb_image == generated_thumb_jpeg).min).to be < 255.0
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
