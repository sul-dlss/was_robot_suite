# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasSeedPreassembly::ContentMetadataGenerator do
  describe 'perform' do
    let(:druid) { 'druid:gh123gh1234' }
    let(:workspace) { 'spec/was_seed_preassembly/fixtures/workspace' }
    let(:instance) { described_class.new }
    let(:object_client) do
      instance_double(Dor::Services::Client::Object, find: object, update: true)
    end
    let(:collection_druid) { 'druid:cc333dd4444' }
    let(:object) { build(:dro, type: Cocina::Models::ObjectType.webarchive_seed, id: druid, collection_ids: [collection_druid]) }
    let(:druid_tool) { instance_double(DruidTools::Druid, content_dir:) }
    let(:content_dir) { "#{workspace}/gh/123/gh/1234/gh123gh1234/content" }

    before do
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
      allow(instance).to receive(:druid).and_return(druid)
      allow(DruidTools::Druid).to receive(:new).and_return(druid_tool)

      FileUtils.mkdir_p(content_dir)
      FileUtils.cp('spec/was_seed_preassembly/fixtures/thumbnail_files/thumbnail.jp2', content_dir)
    end

    it 'generates structural metadata' do
      instance.perform_work
      expect(object_client).to have_received(:update).with(hash_including(:params))
    end
  end
end
