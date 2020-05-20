require 'spec_helper'

describe Dor::WASCrawl::PathIndexerService do
  before(:all) do
    @stacks_path = Pathname(File.dirname(__FILE__)).join('fixtures/stacks')
    @path_files = Pathname(File.dirname(__FILE__)).join('fixtures/path_files')
    @path_working_directory = "#{@stacks_path}/data/indices/path_working"
    @collection_path = '/wasCrawlDissemination/collections/test_collection'
  end

  describe '.merge' do
    before(:all) do
      @druid = 'druid:dd111dd1111'
      @content_metadata_xml_location = 'spec/was_crawl_dissemination/fixtures/metadata/'
    end

    it 'should merge results from contentMetadata to the main path index' do
      content_metadata = File.open(@content_metadata_xml_location + 'contentMetadata_4files.xml').read
      path_index_service = Dor::WASCrawl::PathIndexerService.new(@druid, @collection_path, @path_working_directory, content_metadata)
      path_index_service.instance_variable_set(:@main_path_index_file, "#{@stacks_path}/data/indices/path/path-index.txt")

      path_index_service.merge

      expected_merged_file_path = "#{@path_files}/merged_path_index.txt"
      actual_merged_file_path = "#{@path_working_directory}/merged_path_index.txt"
      expect(File.exist?(actual_merged_file_path)).to eq(true)

      expect(File.read(actual_merged_file_path)).to eq(File.read(expected_merged_file_path))
    end

    after(:all) do
      FileUtils.rm_rf("#{@path_working_directory}/.")
    end
  end

  describe '.sort' do
    it 'should sort and remove duplicate frm the merged path index' do
      FileUtils.cp("#{@path_files}/merged_path_index.txt", "#{@path_working_directory}/merged_path_index.txt")

      path_index_service = Dor::WASCrawl::PathIndexerService.new(@druid, @collection_path, @path_working_directory, '')
      path_index_service.sort

      expected_duplicate_path_index = "#{@path_files}/duplicate_path_index.txt"
      actual_duplicate_path_index = "#{@path_working_directory}/duplicate_path_index.txt"

      expect(File.exist?(actual_duplicate_path_index)).to eq(true)
      expect(File.read(actual_duplicate_path_index)).to eq(File.read(expected_duplicate_path_index))

      expected_path_index = "#{@path_files}/path_index.txt"
      actual_path_index = "#{@path_working_directory}/path_index.txt"

      expect(File.exist?(actual_path_index)).to eq(true)
      expect(File.read(actual_path_index)).to eq(File.read(expected_path_index))
    end

    after(:all) do
      FileUtils.rm_rf("#{@path_working_directory}/.")
    end
  end

  describe '.publish' do
    it 'should copy the new path index to the main path index location' do
      FileUtils.cp("#{@path_files}/path_index.txt", "#{@path_working_directory}/path_index.txt")

      path_index_service = Dor::WASCrawl::PathIndexerService.new(@druid, @collection_path, @path_working_directory, '')
      path_index_service.instance_variable_set(:@main_path_index_file, "#{@stacks_path}/data/indices/path/test_path-index.txt")

      path_index_service.publish

      actual_path_index = "#{@stacks_path}/data/indices/path/test_path-index.txt"
      expect(File.exist?(actual_path_index)).to eq(true)
    end

    after(:all) do
      FileUtils.rm("#{@stacks_path}/data/indices/path/test_path-index.txt")
    end
  end

  describe '.clean' do
    pending
  end
end
