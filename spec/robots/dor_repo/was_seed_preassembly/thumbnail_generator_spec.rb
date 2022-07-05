# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasSeedPreassembly::ThumbnailGenerator do
  describe 'perform' do
    let(:druid) { 'druid:ab123cd4567' }
    let(:instance) { described_class.new }
    let(:url) { 'http://abc123.edu' }
    let(:model) { instance_double(Cocina::Models::DRO, label: url) }
    let(:object_client) { instance_double(Dor::Services::Client::Object, find: model) }

    before do
      allow(Dor::Services::Client).to receive(:object).with(druid).and_return(object_client)
      allow(Dor::WasSeed::ThumbnailGeneratorService).to receive(:capture_thumbnail)
    end

    it 'invokes thumbnail generator service' do
      instance.perform(druid)
      expect(Dor::WasSeed::ThumbnailGeneratorService).to have_received(:capture_thumbnail).with(druid, '/dor/workspace/', url)
    end
  end
end
