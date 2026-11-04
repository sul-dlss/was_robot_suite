# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasSeedPreassembly::ContentMetadataGenerator do
  describe 'perform' do
    let(:druid) { 'druid:gh123gh1234' }
    let(:staging_path) { Dir.mktmpdir }
    let(:instance) { described_class.new }
    let(:object_client) do
      instance_double(Dor::Services::Client::Object, find: object, update: true)
    end
    let(:collection_druid) { 'druid:cc333dd4444' }
    let(:object) { build(:dro, type: Cocina::Models::ObjectType.webarchive_seed, id: druid, collection_ids: [collection_druid]) }
    let(:content_dir) { "#{staging_path}/gh/123/gh/1234/gh123gh1234/content" }

    before do
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
      allow(instance).to receive(:druid).and_return(druid)
      allow(Settings.was_seed).to receive(:staging_path).and_return(staging_path)

      FileUtils.mkdir_p(content_dir)
    end

    after do
      FileUtils.rm_rf(staging_path)
    end

    context 'when there is a thumbnail' do
      before do
        FileUtils.cp('spec/was_seed_preassembly/fixtures/thumbnail_files/thumbnail.jp2', "#{content_dir}/custom.jp2")
      end

      it 'generates structural metadata using the thumbnail filename' do
        instance.perform_work
        expect(object_client).to have_received(:update) do |params:|
          expect(params.structural.contains.first.structural.contains.first.filename).to eq 'custom.jp2'
        end
      end
    end

    context 'when there is no new thumbnail but the structure has a published jp2' do
      let(:object) do
        with_jp2_structural(build(:dro, type: Cocina::Models::ObjectType.webarchive_seed, id: druid, collection_ids: [collection_druid]),
                            publish: true)
      end

      it 'keeps the existing structure' do
        result = instance.perform_work
        expect(result.status).to eq 'skipped'
        expect(object_client).not_to have_received(:update)
      end
    end

    context 'when there is no thumbnail' do
      it 'raises an error' do
        expect { instance.perform_work }.to raise_error(/No jp2 thumbnail found/)
        expect(object_client).not_to have_received(:update)
      end
    end
  end
end
