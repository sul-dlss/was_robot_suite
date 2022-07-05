# frozen_string_literal: true

RSpec.describe Dor::WasCrawl::WarcExtractorService do
  describe '#extract' do
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
end
