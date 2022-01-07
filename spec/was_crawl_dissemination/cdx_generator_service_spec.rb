require 'spec_helper'
RSpec.configure do |c|
  c.filter_run_excluding :openwayback_prerequisite
end

RSpec.describe Dor::WASCrawl::CDXGeneratorService do
  before(:all) do
    @stacks_path = Pathname(File.dirname(__FILE__)).join('fixtures/stacks')
    @workspace   = Pathname(File.dirname(__FILE__)).join('fixtures/workspace')
    @collection_id = 'test_collection'
    @crawl_id      = 'test_crawl'
  end

  describe '#generate_cdx_for_crawl' do
    before(:all) do
      @druid_id_1 = 'dd111dd1111'
      @druid_id_2 = 'dd111dd1111'
      @druid_id_3 = 'ee111ee1111'
      @content_metadata_xml_location = Pathname(File.dirname(__FILE__)).join('fixtures/metadata')
      @collection_path = "#{@stacks_path}/data/collections/test_collection"
    end

    let(:warc_file_list) { Dor::WASCrawl::Dissemination::Utilities.warc_file_list(contentMetadata) }

    context "when contentMetadata has arcs or warcs" do
      let(:contentMetadata) { File.read("#{@content_metadata_xml_location}contentMetadata_3files.xml") }

      it 'generates cdx files for each warc or arc file in contentMetadata', :openwayback_prerequisite do
        cdx_generator = Dor::WASCrawl::CDXGeneratorService.new(@collection_path, @druid_id_1, warc_file_list)

        cdx_generator.instance_variable_set(:@cdx_working_directory, "#{@stacks_path}/data/indices/cdx_working")
        cdx_generator.generate_cdx_for_crawl

        cdx_file_path_1 = "#{@stacks_path}/data/indices/cdx_working/#{@druid_id_1}/WARC-Test.cdx"
        cdx_file_path_2 = "#{@stacks_path}/data/indices/cdx_working/#{@druid_id_1}/ARC-Test.cdx"

        expect(File.exist?(cdx_file_path_1)).to eq(true)
        expect(File.exist?(cdx_file_path_2)).to eq(true)

        actual_cdx_MD5 = Digest::MD5.hexdigest(File.read(cdx_file_path_1))
        expected_cdx_MD5 = Digest::MD5.hexdigest(File.read('spec/fixtures/cdx_files/WARC-Test.cdx'))
        expect(actual_cdx_MD5).to eq(expected_cdx_MD5)

        actual_cdx_MD5 = Digest::MD5.hexdigest(File.read(cdx_file_path_2))
        expected_cdx_MD5 = Digest::MD5.hexdigest(File.read('spec/fixtures/cdx_files/ARC-Test.cdx'))
        expect(actual_cdx_MD5).to eq(expected_cdx_MD5)
      end

      it 'generates cdx files for each warc or arc file in contentMetadata even if there are some file already created', :openwayback_prerequisite do
        # Make sure the test case is correctly setup
        cdx_file_path_1 = "#{@stacks_path}/data/indices/cdx_working/#{@druid_id_2}/WARC-Test.cdx"
        expect(File.exist?(cdx_file_path_1)).to eq(true)

        cdx_generator = Dor::WASCrawl::CDXGeneratorService.new(@collection_path, @druid_id_2, warc_file_list)

        cdx_generator.instance_variable_set(:@cdx_working_directory, "#{@stacks_path}/data/indices/cdx_working")
        cdx_generator.generate_cdx_for_crawl

        cdx_file_path_1 = "#{@stacks_path}/data/indices/cdx_working/#{@druid_id_2}/WARC-Test.cdx"
        cdx_file_path_2 = "#{@stacks_path}/data/indices/cdx_working/#{@druid_id_2}/ARC-Test.cdx"

        expect(File.exist?(cdx_file_path_1)).to eq(true)
        expect(File.exist?(cdx_file_path_2)).to eq(true)

        actual_cdx_MD5   = Digest::MD5.hexdigest(File.read(cdx_file_path_1))
        expected_cdx_MD5 = Digest::MD5.hexdigest(File.read('spec/fixtures/cdx_files/WARC-Test.cdx'))
        expect(actual_cdx_MD5).to eq(expected_cdx_MD5)

        actual_cdx_MD5   = Digest::MD5.hexdigest(File.read(cdx_file_path_2))
        expected_cdx_MD5 = Digest::MD5.hexdigest(File.read('spec/fixtures/cdx_files/ARC-Test.cdx'))
        expect(actual_cdx_MD5).to eq(expected_cdx_MD5)
      end
    end

    context "when contentMetadata has no arcs or warcs" do
      let(:contentMetadata) { File.read("#{@content_metadata_xml_location}contentMetadata_0file.xml") }

      it 'should do nothing for the contentMetadata without any arcs or warcs', :openwayback_prerequisite do
        cdx_generator = Dor::WASCrawl::CDXGeneratorService.new(@collection_path, @druid_id_3, warc_file_list)
        cdx_generator.instance_variable_set(:@cdx_working_directory, "#{@stacks_path}/data/indices/cdx_working")
        cdx_generator.generate_cdx_for_crawl

        cdx_dir = "#{@stacks_path}/data/indices/cdx_working/#{@druid_id_3}/"

        expect(File.exist?(cdx_dir)).to eq(true)
        expect(Dir.glob('#{cdx_dir}{*,.*}').empty?).to eq(true)
      end
    end

    after(:all) do
      FileUtils.rm_rf("#{@stacks_path}/data/indices/cdx_working/#{@druid_id_1}/")
      FileUtils.rm_rf("#{@stacks_path}/data/indices/cdx_working/#{@druid_id_3}/")
      FileUtils.rm_rf("#{@stacks_path}/data/indices/cdx_working/#{@druid_id_2}/ARC-Test.cdx")
    end
  end

  describe '#generate_cdx_for_one_warc' do
    before(:all) do
      @cdx_generator = Dor::WASCrawl::CDXGeneratorService.new('', '', [])
    end

    it 'should generate CDX file for the input warc file', :openwayback_prerequisite do
      cdx_file_path = 'tmp/WARC-Test.cdx'
      warc_file_path = "#{@workspace}/aa111aa1111/WARC-Test.warc.gz"
      @cdx_generator.generate_cdx_for_one_warc(warc_file_path, cdx_file_path)

      expect(File.exist?(cdx_file_path)).to eq(true)

      actual_cdx_MD5 = Digest::MD5.hexdigest(File.read(cdx_file_path))
      expected_cdx_MD5 = Digest::MD5.hexdigest(File.read('spec/fixtures/cdx_files/WARC-Test.cdx'))
      expect(actual_cdx_MD5).to eq(expected_cdx_MD5)
    end

    it 'should generate CDX file for the input arc file', :openwayback_prerequisite do
      cdx_file_path = 'tmp/ARC-Test.cdx'
      warc_file_path = "#{@workspace}/cc111cc1111/ARC-Test.arc.gz"
      @cdx_generator.generate_cdx_for_one_warc(warc_file_path, cdx_file_path)

      expect(File.exist?(cdx_file_path)).to eq(true)

      actual_cdx_MD5 = Digest::MD5.hexdigest(File.read(cdx_file_path))
      expected_cdx_MD5 = Digest::MD5.hexdigest(File.read('spec/fixtures/cdx_files/ARC-Test.cdx'))
      expect(actual_cdx_MD5).to eq(expected_cdx_MD5)
    end

    after(:all) do
      FileUtils.rm 'tmp/WARC-Test.cdx'
      FileUtils.rm 'tmp/ARC-Test.cdx'
    end
  end

  context '.get_cdx_file_name' do
    before(:all) do
      @cdx_generator = Dor::WASCrawl::CDXGeneratorService.new('', '', [])
    end

    it 'should return the cdx file for .warc.gz' do
      warc_file_name = 'file.warc.gz'
      cdx_file_name = @cdx_generator.get_cdx_file_name(warc_file_name)
      expect(cdx_file_name).to eq('file.cdx')
    end

    it 'should return the cdx file for .arc.gz' do
      warc_file_name = 'file.arc.gz'
      cdx_file_name = @cdx_generator.get_cdx_file_name(warc_file_name)
      expect(cdx_file_name).to eq('file.cdx')
    end

    it 'should return the cdx file for .warc' do
      warc_file_name = 'file.warc'
      cdx_file_name = @cdx_generator.get_cdx_file_name(warc_file_name)
      expect(cdx_file_name).to eq('file.cdx')
    end

    it 'should return the cdx file for .arc' do
      warc_file_name = 'file.arc'
      cdx_file_name = @cdx_generator.get_cdx_file_name(warc_file_name)
      expect(cdx_file_name).to eq('file.cdx')
    end

    it 'should return the cdx file for irregular file extension' do
      warc_file_name = 'file.txt'
      cdx_file_name = @cdx_generator.get_cdx_file_name(warc_file_name)
      expect(cdx_file_name).to eq('file.txt.cdx')
    end

    it 'should return the cdx file without the directory path' do
      expect(@cdx_generator.get_cdx_file_name('tmp/file.txt')).to eq('file.txt.cdx')
      expect(@cdx_generator.get_cdx_file_name('./file.txt')).to eq('file.txt.cdx')
      expect(@cdx_generator.get_cdx_file_name('../file.txt')).to eq('file.txt.cdx')
      expect(@cdx_generator.get_cdx_file_name('/tmp/file.txt')).to eq('file.txt.cdx')
      expect(@cdx_generator.get_cdx_file_name('c://tmp/file.txt')).to eq('file.txt.cdx')
      expect(@cdx_generator.get_cdx_file_name('file://tmp/file.txt')).to eq('file.txt.cdx')
    end
  end

  context '.prepare_cdx_generation_cmd_string' do
    before(:all) do
      @cdx_generator = Dor::WASCrawl::CDXGeneratorService.new('', '', [])
    end

    it 'should returns the command string as expected' do
      warc_file_name = 'file.warc'
      cdx_file_name  = 'file.cdx'
      @cdx_generator.instance_variable_set(:@cdx_working_directory, 'working_directory/')
      cmd_string = @cdx_generator.prepare_cdx_generation_cmd_string(warc_file_name, cdx_file_name)
      expect(cmd_string).to eq('jar/openwayback/bin/cdx-indexer file.warc file.cdx 2>> log/cdx_indexer.log')
    end

    it 'should raise an error with nil or missing file names' do
      warc_file_name = nil
      cdx_file_name = 'file.cdx'

      expect { @cdx_generator.prepare_cdx_generation_cmd_string(nil,  cdx_file_name) }.to raise_error StandardError
      expect { @cdx_generator.prepare_cdx_generation_cmd_string('',   cdx_file_name) }.to raise_error StandardError
      expect { @cdx_generator.prepare_cdx_generation_cmd_string(warc_file_name, nil) }.to raise_error StandardError
      expect { @cdx_generator.prepare_cdx_generation_cmd_string(warc_file_name, '') }.to raise_error StandardError
    end
  end

  context Dor::WASCrawl::Dissemination::Utilities, '.run_sys_cmd', :openwayback_prerequisite do
    it 'should generate CDX file in the right location with valid WARC file' do
      warc_file_name = "#{@workspace}/aa111aa1111/WARC-Test.warc.gz"
      cdx_file_name = 'tmp/WARC-Test.cdx'
      cmd_string = "jar/openwayback/bin/cdx-indexer  #{warc_file_name} #{cdx_file_name} 2>> log/cdx_indexer.log"
      Dor::WASCrawl::Dissemination::Utilities.run_sys_cmd(cmd_string, 'extracting CDX')

      expect(File.exist?(cdx_file_name)).to eq(true)

      actual_cdx_MD5 = Digest::MD5.hexdigest(File.read(cdx_file_name))
      expected_cdx_MD5 = Digest::MD5.hexdigest(File.read('spec/fixtures/cdx_files/WARC-Test.cdx'))
      expect(actual_cdx_MD5).to eq(expected_cdx_MD5)
    end

    it 'should raise an error with invalid input file' do
      warc_file_name = '{@workspace}/bb111bbb1111/WARC-Test.txt'
      cdx_file_name = 'tmp/WARC-Test.cdx'
      cmd_string = "jar/openwayback/bin/cdx-indexer  #{warc_file_name} #{cdx_file_name} 2>> log/cdx_indexer.log"
      expect { Dor::WASCrawl::Dissemination::Utilities.run_sys_cmd(cmd_string, 'extracting CDX') }.to raise_error StandardError
    end
  end
end
