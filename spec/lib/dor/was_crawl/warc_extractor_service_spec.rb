# frozen_string_literal: true

RSpec.describe Dor::WasCrawl::WarcExtractorService do
  describe '#extract' do
    context 'when the data package profile is data-package' do
      before do
        FileUtils.cp_r 'spec/lib/dor/was_crawl/fixtures/workspace/dd111dd1111', 'tmp/'
      end

      after do
        FileUtils.rm_rf 'tmp/dd111dd1111'
      end

      it 'extracts the WARC files' do
        described_class.extract('tmp/dd111dd1111', 'WACZ-Test.wacz')
        expect(File.exist?('tmp/dd111dd1111/WACZ-Test-data.warc.gz')).to be true
        expect(File.exist?('tmp/dd111dd1111/WACZ-Test.wacz')).to be false
      end
    end

    context 'when the data package profile is multi-wacz-package' do
      before do
        FileUtils.cp_r 'spec/lib/dor/was_crawl/fixtures/workspace/ee111ee1111', 'tmp/'
      end

      after do
        FileUtils.rm_rf 'tmp/ee111ee1111'
      end

      it 'extracts the WARC files' do
        described_class.extract('tmp/ee111ee1111', 'Multi-WACZ-Test.wacz')
        expect(File.exist?('tmp/ee111ee1111/Multi-WACZ-Test-stanford-library-website-fixture-wacz-manual-20240823165704-eb63421b-c8a-20240823165728702-0.warc.gz')).to be true
        expect(File.exist?('tmp/ee111ee1111/Multi-WACZ-Test-stanford-library-website-fixture-wacz-manual-20240823165704-eb63421b-c8a-screenshots-20240823165731628.warc.gz')).to be false
        expect(File.exist?('tmp/ee111ee1111/Multi-WACZ-Test-stanford-library-website-fixture-wacz-manual-20240823165704-eb63421b-c8a-text-20240823165731772.warc.gz')).to be false
        expect(File.exist?('tmp/ee111ee1111/Multi-WACZ-Test.wacz')).to be false
      end
    end
  end
end
