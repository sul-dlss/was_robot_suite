# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasSeedPreassembly::EndWasSeedPreassembly do
  describe 'perform' do
    subject(:perform) { test_perform(instance, druid) }

    let(:druid) { 'druid:ab123cd4567' }
    let(:instance) { described_class.new }
    let(:object_client) { instance_double(Dor::Services::Client::Object, version: version_client) }
    let(:version_client) { instance_double(Dor::Services::Client::ObjectVersion, current: '1') }

    before do
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
      allow(version_client).to receive(:close)
    end

    context 'with new objects' do
      it 'starts accessioning' do
        perform
        expect(version_client).to have_received(:close)
      end
    end
  end
end
