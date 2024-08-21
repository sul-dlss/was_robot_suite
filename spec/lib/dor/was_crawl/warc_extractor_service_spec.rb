# frozen_string_literal: true

RSpec.describe Dor::WasCrawl::WarcExtractorService do
  describe '#extract' do
    before :all do
      FileUtils.cp_r 'spec/lib/dor/was_crawl/fixtures/workspace/dd111dd1111', 'tmp/'
    end

    after :all do
      FileUtils.rm_rf 'tmp/dd111dd1111'
    end

    context 'when the data package profile is multi-wacz-package' do
      it 'extracts the WARC files' do
        described_class.extract('tmp/dd111dd1111', 'manual-20240813150220-f5365fda-037.wacz')
        expect(File.exist?('tmp/dd111dd1111/manual-20240813150220-f5365fda-037-my-organization-californiahistoricalsociety-org-manual-20240813150220-f5365fda-037-20240813150255048-0.warc.gz')).to be true
        expect(File.exist?('tmp/dd111dd1111/manual-20240813150220-f5365fda-037-my-organization-californiahistoricalsociety-org-manual-20240813150220-f5365fda-037-20240813150259570-1.warc.gz')).to be true
        expect(File.exist?('tmp/dd111dd1111/manual-20240813150220-f5365fda-037-my-organization-californiahistoricalsociety-org-manual-20240813150220-f5365fda-037-20240813150455271-1.warc.gz')).to be true
        expect(File.exist?('tmp/dd111dd1111/manual-20240813150220-f5365fda-037-my-organization-californiahistoricalsociety-org-manual-20240813150220-f5365fda-037-screenshots-20240813150258623.warc.gz')).to be true
        expect(File.exist?('tmp/dd111dd1111/manual-20240813150220-f5365fda-037-my-organization-californiahistoricalsociety-org-manual-20240813150220-f5365fda-037-text-20240813150258797.warc.gz')).to be true
        expect(File.exist?('tmp/dd111dd1111/manual-20240813150220-f5365fda-037-20240813154245913-f5365fda-037-0.wacz')).to be false
      end
    end

    context 'when the data package profile is data-package' do
      it 'extracts the WARC files' do
        described_class.extract('tmp/dd111dd1111', 'WACZ-Test.wacz')
        expect(File.exist?('tmp/dd111dd1111/WACZ-Test-data.warc.gz')).to be true
        expect(File.exist?('tmp/dd111dd1111/WACZ-Test.wacz')).to be false
      end
    end
  end
end
