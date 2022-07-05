# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasSeedPreassembly::DescMetadataGenerator do
  describe 'perform' do
    let(:druid) { 'druid:ab123cd4567' }
    let(:instance) { described_class.new }
    let(:url) { 'http://abc123.edu' }
    let(:collection_id) { 'druid:ab123' }
    let(:model) { instance_double(Cocina::Models::DRO, label: url) }
    let(:collection_model) { instance_double(Cocina::Models::DRO, externalIdentifier: collection_id) }
    let(:object_client) { instance_double(Dor::Services::Client::Object, collections: [collection_model], find: model) }
    let(:generator_service) { instance_double(Dor::WasSeed::DescMetadataGenerator) }

    before do
      allow(Dor::Services::Client).to receive(:object).with(druid).and_return(object_client)
      allow(Dor::WasSeed::DescMetadataGenerator).to receive(:new).and_return(generator_service)
      allow(generator_service).to receive(:generate_metadata_output)
    end

    it 'invokes metadata generator service' do
      instance.perform(druid)
      expect(Dor::WasSeed::DescMetadataGenerator).to have_received(:new).with('/dor/workspace/', druid, url, collection_id)
      expect(generator_service).to have_received(:generate_metadata_output)
    end
  end
end
