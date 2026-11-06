# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasSeedPreassembly::DescMetadataGenerator do
  describe 'perform' do
    let(:druid) { 'druid:ab123cd4567' }
    let(:instance) { described_class.new }
    let(:url) { 'http://abc123.edu' }
    let(:collection_id) { 'druid:ab123' }
    let(:model) { build(:dro).new(description:) }

    let(:description) do
      Cocina::Models::Description.new(purl: 'https://purl.stanford.edu/bc234fg5678',
                                      title: [{ value: url }])
    end
    let(:collection_model) { instance_double(Cocina::Models::DRO, externalIdentifier: collection_id) }
    let(:object_client) { instance_double(Dor::Services::Client::Object, collections: [collection_model], find: model, update: true) }
    let(:temp_dir) { Dir.mktmpdir }
    let(:staging_path) { "#{temp_dir}/assembly" }

    before do
      allow(Dor::Services::Client).to receive(:object).with(druid).and_return(object_client)
      allow(Settings.was_seed).to receive(:staging_path).and_return(staging_path)
    end

    after do
      FileUtils.rm_rf(temp_dir)
    end

    it 'invokes metadata generator service' do
      test_perform(instance, druid)
      expect(object_client).to have_received(:update).with(hash_including(:params))
    end

    context 'when files are staged' do
      let(:staged_content_dir) { "#{staging_path}/ab/123/cd/4567/ab123cd4567/content/images" }

      before do
        FileUtils.mkdir_p(staged_content_dir)
        FileUtils.touch("#{staged_content_dir}/thumbnail.jp2")
      end

      it 'skips generating the description' do
        result = test_perform(instance, druid)
        expect(result.status).to eq 'skipped'
        expect(object_client).not_to have_received(:update)
      end
    end

    context 'when the description has already been generated' do
      let(:description) do
        Cocina::Models::Description.new(purl: 'https://purl.stanford.edu/bc234fg5678',
                                        title: [{ value: 'Edited title' }],
                                        access: { url: [{ value: "https://swap.stanford.edu/*/#{url}", displayLabel: 'Archived website' }] })
      end

      it 'skips generating the description' do
        result = test_perform(instance, druid)
        expect(result.status).to eq 'skipped'
        expect(object_client).not_to have_received(:update)
      end
    end

    context 'when the description has no "Archived website" URL' do
      let(:description) do
        Cocina::Models::Description.new(purl: 'https://purl.stanford.edu/bc234fg5678',
                                        title: [{ value: url }],
                                        access: { url: [{ value: url, displayLabel: 'Other website' }] })
      end

      it 'generates the description' do
        test_perform(instance, druid)
        expect(object_client).to have_received(:update)
      end
    end

    context 'when the seed is not in a collection' do
      let(:object_client) { instance_double(Dor::Services::Client::Object, collections: [], find: model, update: true) }

      it 'raises an error' do
        expect { test_perform(instance, druid) }.to raise_error(/Expect at least one collection for #{druid}/)
        expect(object_client).not_to have_received(:update)
      end
    end

    context 'when the staging content directory exists but is empty' do
      before do
        FileUtils.mkdir_p("#{staging_path}/ab/123/cd/4567/ab123cd4567/content")
      end

      it 'invokes metadata generator service' do
        test_perform(instance, druid)
        expect(object_client).to have_received(:update).with(hash_including(:params))
      end
    end
  end
end
