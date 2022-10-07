# frozen_string_literal: true

RSpec.describe Dor::WasCrawl::Dissemination::Utilities do
  describe '.run_sys_cmd' do
    it 'returns nothing with succesful command' do
      expect(described_class.run_sys_cmd('ls', '')).to be_nil
    end

    it 'raises an error with wrong command' do
      expect { described_class.run_sys_cmd('lss', '') }.to raise_error StandardError
    end
  end

  describe 'file location info' do
    let(:druid) { 'druid:dd111dd1111' }
    let(:collection_druid) { 'druid:cc333dd4444' }
    let(:collections_path) { 'spec/lib/dor/was_crawl/fixtures/stacks/data/collections' }

    let(:object_client) do
      instance_double(Dor::Services::Client::Object, find: object)
    end
    let(:object) { build(:dro, id: druid, collection_ids: [collection_druid]) }

    before do
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
      allow(Settings.was_crawl_dissemination).to receive(:stacks_collections_path).and_return(collections_path)
    end

    describe '.warc_file_location_info' do
      it 'returns file info' do
        expect(described_class.warc_file_location_info(druid)).to eq({
                                                                       collection_id: 'cc333dd4444',
                                                                       collection_path: "#{collections_path}/cc333dd4444",
                                                                       item_path: "#{collections_path}/cc333dd4444/dd/111/dd/1111",
                                                                       file_list: ['ARC-Test.arc.gz', 'WARC-Test.warc.gz']
                                                                     })
      end
    end

    describe '.wacz_file_location_info' do
      it 'returns file info' do
        expect(described_class.wacz_file_location_info(druid)).to eq({
                                                                       collection_id: 'cc333dd4444',
                                                                       collection_path: "#{collections_path}/cc333dd4444",
                                                                       item_path: "#{collections_path}/cc333dd4444/dd/111/dd/1111",
                                                                       file_list: ['WACZ-Test.wacz']
                                                                     })
      end
    end
  end

  describe '.get_collection_id' do
    let(:druid_obj) { double(Cocina::Models::DRO) }

    it 'delegates to Dor::WasCrawl::Utilities' do
      expect(Dor::WasCrawl::Utilities).to receive(:get_collection_id).with(druid_obj).and_return('abc')
      expect(described_class.get_collection_id(druid_obj)).to eq 'abc'
    end
  end
end
