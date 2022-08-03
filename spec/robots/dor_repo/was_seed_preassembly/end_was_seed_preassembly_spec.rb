# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasSeedPreassembly::EndWasSeedPreassembly do
  describe 'perform' do
    subject(:perform) { instance.perform(druid) }

    let(:druid) { 'druid:ab123cd4567' }
    let(:instance) { described_class.new }
    let(:accession_object) { instance_double(Dor::Services::Client::Accession, start: true) }
    let(:object_client) { instance_double(Dor::Services::Client::Object, accession: accession_object) }

    before do
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
    end

    context 'with new objects' do
      it 'starts accessioning' do
        perform
        expect(object_client.accession).to have_received(:start).with(
          workflow: 'accessionWF',
          significance: 'major',
          description: 'wasSeedPreassembly'
        )
      end
    end

    context 'with objects for which the start accession call fails' do
      before do
        allow(object_client).to receive(:accession).and_raise(StandardError)
      end

      it 'issues an error' do
        expect { perform }.to raise_error(StandardError)
      end
    end
  end
end
