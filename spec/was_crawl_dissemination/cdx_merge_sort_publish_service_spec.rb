require 'spec_helper'

describe Dor::WASCrawl::CDXMergeSortPublishService do
  let(:cdx_file_path) { Pathname(File.dirname(__FILE__)).join('fixtures/cdx_files') }

  before(:all) do
    # need to be @ so after(:all) can access
    @stacks_path = Pathname(File.dirname(__FILE__)).join('fixtures/stacks')
    @cdx_working_dir = "#{@stacks_path}/data/indices/cdx_working"
  end

  describe '.sort_druid_cdx' do
    after(:all) do
      FileUtils.rm_rf("#{@cdx_working_dir}/ff111ff1111_merged_index.cdx")
    end

    it 'sorts and merges all cdx files within the druid directory' do
      druid = 'ff111ff1111'

      mergeSortPublishService = described_class.new(druid, @cdx_working_dir, '')
      mergeSortPublishService.sort_druid_cdx

      expected_merged_file_path = "#{cdx_file_path}/#{druid}_merged_index.cdx"
      actual_merged_file_path = "#{@cdx_working_dir}/#{druid}_merged_index.cdx"
      expect(File.exist?(actual_merged_file_path)).to eq true

      actual_cdx_MD5 = Digest::MD5.hexdigest(File.read(actual_merged_file_path))
      expected_cdx_MD5 = Digest::MD5.hexdigest(File.read(expected_merged_file_path))
      expect(actual_cdx_MD5).to eq expected_cdx_MD5
    end
  end

  describe '.merge_with_main_index' do
    after(:all) do
      FileUtils.rm_rf("#{@cdx_working_dir}/gg111gg1111_sorted_index.cdx")
      FileUtils.rm_rf("#{@cdx_working_dir}/gg111gg1111_sorted_duplicate_index.cdx")
    end

    it 'sorts and removes duplicates from merged index' do
      druid = 'gg111gg1111'

      mergeSortPublishService = described_class.new(druid, @cdx_working_dir, '')
      mergeSortPublishService.instance_variable_set(:@main_cdx_file, "#{@stacks_path}/data/indices/cdx/index.cdx")
      mergeSortPublishService.merge_with_main_index

      expected_sorted = "#{cdx_file_path}/#{druid}_sorted_index.cdx"
      actual_sorted = "#{@cdx_working_dir}/#{druid}_sorted_index.cdx"
      expect(File.exist?(actual_sorted)).to eq true
      actual_cdx_MD5 = Digest::MD5.hexdigest(File.read(actual_sorted))
      expected_cdx_MD5 = Digest::MD5.hexdigest(File.read(expected_sorted))
      expect(actual_cdx_MD5).to eq expected_cdx_MD5
    end
  end

  context 'publish' do
    before(:all) do
      # needs to be @ so after(:all) can access it
      @main_cdx_file = "#{@stacks_path}/data/indices/cdx/g_index.cdx"
    end

    after(:all) do
      # ?? File kept so git will tell us if it changes (and therefore test not working right?) ??
      FileUtils.mv(@main_cdx_file, "#{@cdx_working_dir}/hh111hh1111_sorted_index.cdx")
    end

    it 'moves sorted_index cdx to main_cdx_file location' do
      druid = 'hh111hh1111'

      mergeSortPublishService = described_class.new(druid, @cdx_working_dir, '')
      mergeSortPublishService.instance_variable_set(:@main_cdx_file, @main_cdx_file)
      expect(File.exist?(mergeSortPublishService.instance_variable_get(:@working_sorted_cdx))).to eq true
      expect(File.exist?(mergeSortPublishService.instance_variable_get(:@main_cdx_file))).to eq false

      mergeSortPublishService.publish
      expect(File.exist?(mergeSortPublishService.instance_variable_get(:@working_sorted_cdx))).to eq false
      expect(File.exist?(mergeSortPublishService.instance_variable_get(:@main_cdx_file))).to eq true
    end
  end

  describe '.clean' do
    before(:all) do
      # needs to be @ so after(:all) can access it
      @cdx_backup_dir = "#{@stacks_path}/data/indices/cdx_backup"
      @druid = 'ii111ii1111'
    end

    after(:all) do
      FileUtils.rm_rf(Dir.glob("#{@cdx_backup_dir}/#{@druid}*"))
    end

    it 'moves cdx files to cdx backup directory (from source_dir)' do
      FileUtils.cp_r("#{cdx_file_path}/ii/.", @cdx_working_dir)
      mergeSortPublishService = described_class.new(@druid, @cdx_working_dir, @cdx_backup_dir)

      expect(File.exist?(mergeSortPublishService.instance_variable_get(:@source_cdx_dir))).to eq true
      expect(File.exist?("#{@cdx_working_dir}/#{@druid}_merged_index.cdx")).to eq true
      expect(File.exist?("#{@cdx_working_dir}/#{@druid}_sorted_duplicate_index.cdx")).to eq true
      expect(File.exist?("#{@cdx_backup_dir}/#{@druid}")).to eq false
      expect(File.exist?("#{@cdx_backup_dir}/#{@druid}/file1.cdx")).to eq false
      expect(File.exist?("#{@cdx_backup_dir}/#{@druid}/file2.cdx")).to eq false

      mergeSortPublishService.clean
      expect(File.exist?(mergeSortPublishService.instance_variable_get(:@source_cdx_dir))).to eq false
      expect(File.exist?("#{@cdx_working_dir}/#{@druid}_merged_index.cdx")).to eq false
      expect(File.exist?("#{@cdx_working_dir}/#{@druid}_sorted_duplicate_index.cdx")).to eq false
      expect(File.exist?("#{@cdx_backup_dir}/#{@druid}")).to eq true
      expect(File.exist?("#{@cdx_backup_dir}/#{@druid}/file1.cdx")).to eq true
      expect(File.exist?("#{@cdx_backup_dir}/#{@druid}/file2.cdx")).to eq true
      # merged_index.cdx and sorted_duplicate_index.cdx are not kept
      expect(File.exist?("#{@cdx_backup_dir}/#{@druid}_merged_index.cdx")).to eq false
      expect(File.exist?("#{@cdx_backup_dir}/#{@druid}_sorted_duplicate_index.cdx")).to eq false
    end

    it 'moves cdx files to cdx backup directory when the @druid directory already exists' do
      FileUtils.cp_r("#{cdx_file_path}/ii/.", @cdx_backup_dir)

      mergeSortPublishService = described_class.new(@druid, @cdx_working_dir, @cdx_backup_dir)
      expect(File.exist?("#{@cdx_backup_dir}/#{@druid}")).to eq true

      # it's okay if it complains about the files;  we are specifically concerned about the directory
      expect { mergeSortPublishService.clean }.not_to raise_error(StandardError, "File exists - #{@cdx_backup_dir}/#{@druid}")
    end
  end
end
