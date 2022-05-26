require 'spec_helper'
require 'was_crawl_preassembly/metadata_extractor_service'

describe Dor::WASCrawl::MetadataExtractor do
  let(:extractor) { described_class.new('test_collection', 'test_crawl', staging_path, 'druid:ab123ab1234') }
  let(:staging_path) { Pathname(File.dirname(__FILE__)).join('../fixtures/workspace') }

  before do
    allow(File).to receive(:write)
  end

  it 'generates XML file' do
    extractor.run
    expect(File).to have_received(:write).with('tmp/druid:ab123ab1234.xml', <<~XML
      <?xml version="1.0"?>
      <crawlObject>
        <crawlId>test_crawl</crawlId>
        <collectionId>test_collection</collectionId>
        <files>
          <file>
            <name>WARC-Test.warc.gz</name>
            <type>WARC</type>
            <size>6608320</size>
            <mimeType>application/warc</mimeType>
            <checksumMD5>c7edbde066e4697b3f2d823ac42c3692</checksumMD5>
            <checksumSHA1>3a9f2ffac1497c70291d93a8bc86c1469547d8f8</checksumSHA1>
          </file>
        </files>
      </crawlObject>
    XML
    )
  end
end
