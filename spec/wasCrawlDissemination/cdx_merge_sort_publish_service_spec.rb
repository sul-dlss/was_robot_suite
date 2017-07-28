require 'spec_helper'

describe Dor::WASCrawl::CDXMergeSortPublishService do
  let(:cdx_file_path) { Pathname(File.dirname(__FILE__)).join('fixtures/cdx_files') }
  before(:all) do
    # @stacks_path needs to be @ so after(:all) can access it
    @stacks_path = Pathname(File.dirname(__FILE__)).join('fixtures/stacks')
    @cdx_working_dir = "#{@stacks_path}/data/indices/cdx_working"
  end

  describe '.sort_druid_cdx' do
    it 'should merge and sort all cdx files within the druid directory' do
      druid = 'ff111ff1111'

      mergeSortPublishService = Dor::WASCrawl::CDXMergeSortPublishService.new(druid, @cdx_working_dir, '')
      mergeSortPublishService.sort_druid_cdx

      expected_merged_file_path = "#{cdx_file_path}/#{druid}_merged_index.cdx"
      actual_merged_file_path = "#{@cdx_working_dir}/#{druid}_merged_index.cdx"
      expect(File.exist?(actual_merged_file_path)).to eq true

      actual_cdx_MD5 = Digest::MD5.hexdigest(File.read(actual_merged_file_path))
      expected_cdx_MD5 = Digest::MD5.hexdigest(File.read(expected_merged_file_path))
      expect(actual_cdx_MD5).to eq expected_cdx_MD5
    end

    after(:all) do
      FileUtils.rm_rf("#{@cdx_working_dir}/ff111ff1111_merged_index.cdx")
    end
  end

  describe '.merge_with_main_index' do
    it 'should sort and remove duplicate from the merged index' do
      druid = 'gg111gg1111'

      mergeSortPublishService = Dor::WASCrawl::CDXMergeSortPublishService.new(druid, @cdx_working_dir, '')
      mergeSortPublishService.instance_variable_set(:@main_cdx_file, "#{@stacks_path}/data/indices/cdx/index.cdx")
      mergeSortPublishService.merge_with_main_index

      expected_sorted = "#{cdx_file_path}/#{druid}_sorted_index.cdx"
      actual_sorted = "#{@cdx_working_dir}/#{druid}_sorted_index.cdx"
      expect(File.exist?(actual_sorted)).to eq true
      actual_cdx_MD5 = Digest::MD5.hexdigest(File.read(actual_sorted))
      expected_cdx_MD5 = Digest::MD5.hexdigest(File.read(expected_sorted))
      expect(actual_cdx_MD5).to eq expected_cdx_MD5
    end

    after(:all) do
      FileUtils.rm_rf("#{@cdx_working_dir}/gg111gg1111_sorted_index.cdx")
      FileUtils.rm_rf("#{@cdx_working_dir}/gg111gg1111_sorted_duplicate_index.cdx")
    end
  end

  context 'publish' do
    it 'should publish the cdx main index to indices/cdx location' do
      druid = 'hh111hh1111'

      mergeSortPublishService = Dor::WASCrawl::CDXMergeSortPublishService.new(druid, @cdx_working_dir, '')
      mergeSortPublishService.instance_variable_set(:@main_cdx_file, "#{@stacks_path}/data/indices/cdx/g_index.cdx")
      expect(File.exist?("#{@stacks_path}/data/indices/cdx/g_index.cdx")).to eq false

      mergeSortPublishService.publish
      expect(File.exist?("#{@stacks_path}/data/indices/cdx/g_index.cdx")).to eq true
    end

    after(:all) do
      # FIXME: why do we want this?  Wouldn't we want to delete the file, instead of moving it?
      FileUtils.mv("#{@stacks_path}/data/indices/cdx/g_index.cdx", "#{@cdx_working_dir}/hh111hh1111_sorted_index.cdx")
    end
  end

  describe '.clean' do
    before(:all) do
      # needs to be @ so after(:all) can access it
      @cdx_backup_dir = "#{@stacks_path}/data/indices/cdx_backup"
    end
    it 'should clean all the working directory and move the files to backup' do
      druid = 'ii111ii1111'
      FileUtils.cp_r("#{cdx_file_path}/ii/.", "#{@cdx_working_dir}")

      mergeSortPublishService = Dor::WASCrawl::CDXMergeSortPublishService.new(druid, @cdx_working_dir, @cdx_backup_dir)
      mergeSortPublishService.clean

      expect(File.exist?("#{@cdx_backup_dir}/ii111ii1111")).to eq(true)
      expect(File.exist?("#{@cdx_backup_dir}/ii111ii1111/file1.cdx")).to eq(true)
      expect(File.exist?("#{@cdx_backup_dir}/ii111ii1111/file2.cdx")).to eq(true)
      expect(File.exist?("#{@cdx_backup_dir}/ii111ii1111_merged_index.cdx")).to eq(false)
      expect(File.exist?("#{@cdx_backup_dir}/ii111ii1111_sorted_duplicate_index.cdx")).to eq(false)
    end

    after(:all) do
      FileUtils.rm_rf("#{@cdx_backup_dir}/.")
    end
  end
end
