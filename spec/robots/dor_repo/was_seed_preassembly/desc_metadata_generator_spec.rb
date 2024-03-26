# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasSeedPreassembly::DescMetadataGenerator do
  describe 'perform' do
    let(:druid) { 'druid:ab123cd4567' }
    let(:instance) { described_class.new }
    let(:url) { 'http://abc123.edu' }
    let(:collection_id) { 'druid:ab123' }
    let(:model) { build(:dro, label: url).new(description:) }

    let(:description) do
      Cocina::Models::Description.new(purl: 'https://purl.stanford.edu/bc234fg5678',
                                      title: [{ value: 'https://www.nancyforlosaltos.com/' }])
    end
    let(:collection_model) { instance_double(Cocina::Models::DRO, externalIdentifier: collection_id) }
    let(:object_client) { instance_double(Dor::Services::Client::Object, collections: [collection_model], find: model, update: true) }

    before do
      allow(Dor::Services::Client).to receive(:object).with(druid).and_return(object_client)
    end

    it 'invokes metadata generator service' do
      test_perform(instance, druid)
      expect(object_client).to have_received(:update).with(hash_including(:params))
    end
  end
end
