require 'spec_helper'

RSpec.describe Dor::WASCrawl::PathIndexerService do
  before(:all) do
    @stacks_path = Pathname(File.dirname(__FILE__)).join('fixtures/stacks')
    @path_files = Pathname(File.dirname(__FILE__)).join('fixtures/path_files')
    @path_working_directory = "#{@stacks_path}/data/indices/path_working"
    @collection_path = '/wasCrawlDissemination/collections/test_collection'
  end

  describe '#merge' do
    let(:druid) { 'druid:dd111dd1111' }
    let(:warc_file_list) { ["WARC-Test.warc.gz", "ARC-Test.arc.gz"] }

    it 'merges results from warc_file_list to the main path index' do
      path_index_service = described_class.new(druid, @collection_path, @path_working_directory, warc_file_list)
      path_index_service.instance_variable_set(:@main_path_index_file, "#{@stacks_path}/data/indices/path/path-index.txt")

      path_index_service.merge

      expected_merged_file_path = "#{@path_files}/merged_path_index.txt"
      actual_merged_file_path = "#{@path_working_directory}/merged_path_index.txt"
      expect(File.exist?(actual_merged_file_path)).to eq(true)

      expect(File.read(actual_merged_file_path)).to eq(File.read(expected_merged_file_path))
    end
  end

  describe '#sort' do
    it 'sorts and remove duplicate frm the merged path index' do
      FileUtils.cp("#{@path_files}/merged_path_index.txt", "#{@path_working_directory}/merged_path_index.txt")

      path_index_service = described_class.new(@druid, @collection_path, @path_working_directory, [])
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
  end

  describe '#publish' do
    after(:all) do
      FileUtils.rm("#{@stacks_path}/data/indices/path/test_path-index.txt")
    end

    it 'copies the new path index to the main path index location' do
      FileUtils.cp("#{@path_files}/path_index.txt", "#{@path_working_directory}/path_index.txt")

      path_index_service = described_class.new(@druid, @collection_path, @path_working_directory, [])
      path_index_service.instance_variable_set(:@main_path_index_file, "#{@stacks_path}/data/indices/path/test_path-index.txt")

      path_index_service.publish

      actual_path_index = "#{@stacks_path}/data/indices/path/test_path-index.txt"
      expect(File.exist?(actual_path_index)).to eq(true)
    end
  end

  describe '.clean' do
    pending
  end
end
