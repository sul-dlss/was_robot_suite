require 'spec_helper'
require 'was_crawl_preassembly/metadata_extractor_service'

describe Dor::WASCrawl::MetadataExtractor do
  before(:all) do
    @staging_path = Pathname(File.dirname(__FILE__)).join('../fixtures/workspace')
    @collection_id = 'test_collection'
    @crawl_id = 'test_crawl'
  end

  context described_class, '.call_java_library with druid that has one warc file' do
    it 'calls out to java CLI for .run_metadata_extractor_jar' do
      druid_id = 'druid:ab123ab1234'
      metadata_extractor_service = described_class.new(@collection_id, @crawl_id, @staging_path.to_s, druid_id)
      expected_cmd_string = %r{java .*-jar jar/WASMetadataExtractor.jar -f XML .*/ab123ab1234/content -o tmp/druid:ab123ab1234.xml -c config/extractor.yml --collectionId #{@collection_id} --crawlId #{@crawl_id}}
      expect(metadata_extractor_service).to receive(:system).with(expected_cmd_string).and_return(true) # leave WASMetadataExtractor testing to its repo
      metadata_extractor_service.run_metadata_extractor_jar
    end
  end

  context described_class, '.prepare_parameters' do
    it 'should run successfully with existent druid' do
      druid_id = 'druid:ab123ab1234'
      metadata_extractor_service = described_class.new(@collection_id, @crawl_id, @staging_path.to_s, druid_id)
      metadata_extractor_service.prepare_parameters
      expect(metadata_extractor_service.instance_variable_get(:@input_directory)).to eq "#{@staging_path}/ab/123/ab/1234/ab123ab1234/content"
      expect(metadata_extractor_service.instance_variable_get(:@xml_output_location)).to eq 'tmp/druid:ab123ab1234.xml'
    end

    it 'should raise an error wrong druid' do
      druid_id = 'druid:xx999xxx9999'
      metadata_extractor_service = described_class.new(@collection_id, @crawl_id, @staging_path.to_s, druid_id)
      expect { metadata_extractor_service.prepare_parameters }.to raise_error(ArgumentError, /Invalid DRUID/)
    end

    it 'should raise an error with nil druid' do
      druid_id = nil
      metadata_extractor_service = described_class.new(@collection_id, @crawl_id, @staging_path.to_s, druid_id)
      expect { metadata_extractor_service.prepare_parameters }.to raise_error(ArgumentError, /Invalid DRUID/)
    end

    it 'should raise an error with existent druid tree without content folder' do
      druid_id = 'druid:ef123ef1234'
      metadata_extractor_service = described_class.new(@collection_id, @crawl_id, @staging_path.to_s, druid_id)
      expect { metadata_extractor_service.prepare_parameters }.to raise_error(RuntimeError, /content doesn't exist/)
    end
  end

  context described_class, '.build_cmd_string' do
    it 'should build the command string as expected' do
      druid_id = 'druid:ab123ab1234'
      expected_cmd_string = 'java -Xmx2048m -jar jar_path -f XML -d input_directory -o tmp/druid:ab123ab1234.xml -c config/extractor.yml --collectionId test_collection --crawlId test_crawl 2>> log_file'

      metadata_extractor_service = described_class.new(@collection_id, @crawl_id, @staging_path.to_s, druid_id)
      metadata_extractor_service.instance_variable_set(:@jar_path, 'jar_path')
      metadata_extractor_service.instance_variable_set(:@input_directory, 'input_directory')
      metadata_extractor_service.instance_variable_set(:@java_log_file, 'log_file')
      metadata_extractor_service.instance_variable_set(:@xml_output_location, 'tmp/druid:ab123ab1234.xml')

      actual_cmd_string = metadata_extractor_service.build_cmd_string
      expect(actual_cmd_string).to eq expected_cmd_string
    end
  end
end
