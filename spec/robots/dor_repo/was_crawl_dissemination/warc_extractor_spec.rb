# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasCrawlDissemination::WarcExtractor do
  subject(:robot) { described_class.new }

  describe '.perform' do
    subject(:perform) { test_perform(robot, druid) }

    let(:druid) { 'druid:dd116zh0343' }
    # let(:object_client) do
    #   instance_double(Dor::Services::Client::Object, find: object)
    # end

    # let(:object) { build(:dro, id: druid, collection_ids: ['druid:xx123xx1234']) }

    before do
      # allow(Dor::Services::Client).to receive(:object).and_return(object_client)
      allow(Dor::WasCrawl::Dissemination::Utilities).to receive(:wacz_file_location_info).with(druid).and_return(
        { item_path: '/web-archiving-stacks/data/collections/xx123xx1234/dd/116/zh/0343', file_list: ['number1.wacz'] }
      )
      allow(Dor::WasCrawl::WarcExtractorService).to receive(:extract)
    end

    it 'calls the warc extractor' do
      perform
      expect(Dor::WasCrawl::WarcExtractorService).to have_received(:extract).with('/web-archiving-stacks/data/collections/xx123xx1234/dd/116/zh/0343', 'number1.wacz')
    end
  end
end
