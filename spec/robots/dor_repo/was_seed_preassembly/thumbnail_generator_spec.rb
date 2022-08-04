# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasSeedPreassembly::ThumbnailGenerator do
  describe 'perform' do
    let(:druid) { 'druid:bc123df4567' }
    let(:instance) { described_class.new }
    let(:url) { 'http://abc123.edu' }
    let(:object_client) { instance_double(Dor::Services::Client::Object, find: cocina_model) }

    before do
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
      allow(Dor::WasSeed::ThumbnailGeneratorService).to receive(:capture_thumbnail)
    end

    context 'when generating a thumbnail when there is no note yet' do
      let(:cocina_model) do
        build(:dro, id: druid).new(description: {
                                     purl: 'https://purl.stanford.edu/bc123df4567',
                                     title: [
                                       {
                                         value: 'http://abc123.edu'
                                       }
                                     ]
                                   })
      end

      it 'invokes thumbnail generator service and finds the URI in the title' do
        instance.perform(druid)
        expect(Dor::Services::Client).to have_received(:object).with(druid)
        expect(Dor::WasSeed::ThumbnailGeneratorService).to have_received(:capture_thumbnail).with(druid, '/dor/workspace/', url)
      end
    end

    context 'when re-generating a thumbnail' do
      let(:cocina_model) do
        build(:dro, id: druid).new(description: {
                                     purl: 'https://purl.stanford.edu/bc123df4567',
                                     note: [
                                       {
                                         value: url,
                                         displayLabel: 'Original site'
                                       }
                                     ],
                                     title: [
                                       {
                                         value: 'Web Archive Seed for http://abc123.edu'
                                       }
                                     ]
                                   })
      end

      it 'invokes thumbnail generator service and finds the URI in the note' do
        instance.perform(druid)
        expect(Dor::Services::Client).to have_received(:object).with(druid)
        expect(Dor::WasSeed::ThumbnailGeneratorService).to have_received(:capture_thumbnail).with(druid, '/dor/workspace/', url)
      end
    end

    context 'when re-generating the thumbnail and title has been updated but there is no note' do
      let(:cocina_model) do
        build(:dro, id: druid, label: url).new(description: {
                                                 purl: 'https://purl.stanford.edu/bc123df4567',
                                                 title: [
                                                   {
                                                     value: 'Web Archive Seed for http://abc123.edu'
                                                   }
                                                 ]
                                               })
      end

      it 'invokes thumbnail generator service and finds the URI in the label' do
        instance.perform(druid)
        expect(Dor::Services::Client).to have_received(:object).with(druid)
        expect(Dor::WasSeed::ThumbnailGeneratorService).to have_received(:capture_thumbnail).with(druid, '/dor/workspace/', url)
      end
    end
  end
end
