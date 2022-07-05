# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasCrawlDissemination::CdxjGenerator do
  subject(:robot) { described_class.new }

  describe '.perform' do
    subject(:perform) { robot.perform(druid) }

    let(:druid) { 'druid:dd116zh0343' }
    let(:sys_cmd) do
      '/opt/app/was/.local/bin/cdxj-indexer /web-archiving-stacks/data/collections/xx123xx1234/dd/116/zh/0343/number1.warc ' \
        '--output tmp/druid:dd116zh0343/number1.cdxj --dir-root /web-archiving-stacks/data/collections/ --post-append 2>> log/cdx_indexer.log'
    end

    before do
      allow(Dor::WasCrawl::Dissemination::Utilities).to receive(:run_sys_cmd)
      allow(Dor::WasCrawl::Dissemination::Utilities).to receive(:warc_file_location_info).with(druid).and_return(
        { collection_path: '/web-archiving-stacks/data/collections/xx123xx1234', file_list: ['number1.warc'] }
      )
    end

    it 'runs the cdxj-indexer' do
      perform
      expect(Dor::WasCrawl::Dissemination::Utilities).to have_received(:run_sys_cmd)
        .with(sys_cmd, "extracting CDXJ")
    end
  end
end
