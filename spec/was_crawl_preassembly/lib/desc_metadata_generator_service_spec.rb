require 'spec_helper'
require 'was_crawl_preassembly/desc_metadata_generator_service'

describe Dor::WASCrawl::DescMetadataGenerator do
  before(:all) do
    @staging_path = Pathname(File.dirname(__FILE__)).join('../fixtures/workspace')
    @extracted_metadata_xml_location = Pathname(File.dirname(__FILE__)).join('../fixtures/xml_extracted_metadata')
    @collection_id = 'test_collection'
    @crawl_id = 'test_crawl'
    generate_data_items
  end

  context Dor::WASCrawl::DescMetadataGenerator, 'generate_metadata_output' do
    it 'should generate technicalMetadata with valid input' do
      druid_id = 'druid:gh123gh1234'
      metadata_generator_service = generate_object(druid_id)
      metadata_generator_service.instance_variable_set(:@extracted_metadata_xml_location, @extracted_metadata_xml_location)
      # receiver = double(metadata_generator_service)
      allow(metadata_generator_service).to receive(:generate_xml_doc).and_return("<?xml version=\"1.0\"?><title>test</title>")

      metadata_generator_service.generate_metadata_output
      actual_desc_metadata = File.read "#{@staging_path}/gh/123/gh/1234/gh123gh1234/metadata/descMetadata.xml"
      expect(actual_desc_metadata).to eq @expected_desc_metadata
    end

    after(:each) do
      File.delete "#{@staging_path}/gh/123/gh/1234/gh123gh1234/metadata/descMetadata.xml"
    end
  end

  context Dor::WASCrawl::DescMetadataGenerator, 'generate_xml_doc' do
  end

  def generate_object(druid_id)
    metadata_generator_service = Dor::WASCrawl::DescMetadataGenerator.new(@collection_id,
                                                                          @staging_path.to_s, druid_id)
    metadata_generator_service
  end

  def generate_data_items
    @expected_desc_metadata = <<~EOF
      <?xml version="1.0"?>
      <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns=\"http://www.loc.gov/mods/v3\" version="3.3" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd">
        <titleInfo>
          <title>test</title>
        </titleInfo>
      </mods>
    EOF
  end
end
