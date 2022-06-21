# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robots::DorRepo::WasCrawlDissemination::CdxjGenerator do
  subject(:robot) { described_class.new }

  describe '.perform' do
    subject(:perform) { robot.perform(druid) }

    let(:druid) { 'druid:dd116zh0343' }
    let(:object_client) do
      instance_double(Dor::Services::Client::Object, find: object)
    end

    let(:object) { build(:dro, id: druid, collection_ids: ['druid:xx123xx1234']) }

    before do
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
      allow(Dor::WasCrawl::Dissemination::Utilities).to receive(:run_sys_cmd)
      allow(Dor::WasCrawl::Dissemination::Utilities).to receive(:warc_file_list).and_return(['foo/number1.warc'])
    end

    it 'runs the cdxj-indexer' do
      perform
      expect(Dor::WasCrawl::Dissemination::Utilities).to have_received(:run_sys_cmd)
        .with('/opt/app/was/.local/bin/cdxj-indexer /web-archiving-stacks/data/collections/xx123xx1234/dd/116/zh/0343/foo/number1.warc --output tmp/druid:dd116zh0343/number1.cdxj --post-append 2>> log/cdx_indexer.log',
              "extracting CDXJ")
    end
  end
end
