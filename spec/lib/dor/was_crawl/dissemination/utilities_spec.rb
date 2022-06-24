require 'spec_helper'

RSpec.describe Dor::WasCrawl::Dissemination::Utilities do
  describe '.run_sys_cmd' do
    it 'returns nothing with succesful command' do
      described_class.run_sys_cmd('ls', '')
    end

    it 'raises an error with wrong command' do
      expect { described_class.run_sys_cmd('lss', '') }.to raise_error StandardError
    end
  end

  describe '.warc_file_list and .wacz_file_list' do
    let(:fs_structural) { instance_double(Cocina::Models::FileSetStructural, contains: files) }
    let(:fileset) { instance_double(Cocina::Models::FileSet, structural: fs_structural) }

    let(:cocina_model) { instance_double(Cocina::Models::DRO, structural: structural) }

    context 'with 5 files' do
      let(:structural) do
        Cocina::Models::DROStructural.new(contains: [
                                            { type: Cocina::Models::FileSetType.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file1] } },
                                            { type: Cocina::Models::FileSetType.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file2] } },
                                            { type: Cocina::Models::FileSetType.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file3] } },
                                            { type: Cocina::Models::FileSetType.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file4] } },
                                            { type: Cocina::Models::FileSetType.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file5] } }
                                          ])
      end
      let(:file1) do
        Cocina::Models::File.new(type: Cocina::Models::ObjectType.file, externalIdentifier: '',
                                 label: '', filename: 'WARC-Test.warc.gz', version: 1,
                                 administrative: { shelve: true })
      end
      let(:file2) do
        Cocina::Models::File.new(type: Cocina::Models::ObjectType.file, externalIdentifier: '',
                                 label: '', filename: 'ARC-Test.arc.gz', version: 1,
                                 administrative: { shelve: true })
      end
      let(:file3) do
        Cocina::Models::File.new(type: Cocina::Models::ObjectType.file, externalIdentifier: '',
                                 label: '', filename: 'test.txt', version: 1,
                                 administrative: { shelve: false })
      end
      let(:file4) do
        Cocina::Models::File.new(type: Cocina::Models::ObjectType.file, externalIdentifier: '',
                                 label: '', filename: 'ARC-Test2.arc.gz', version: 1,
                                 administrative: { shelve: false })
      end
      let(:file5) do
        Cocina::Models::File.new(type: Cocina::Models::ObjectType.file, externalIdentifier: '',
                                 label: '', filename: 'WACZ-Test.wacz', version: 1,
                                 administrative: { shelve: true })
      end

      it 'returns a list for the extracted arc and warc files' do
        expect(described_class.warc_file_list(cocina_model)).to eq ["WARC-Test.warc.gz", "ARC-Test.arc.gz"]
      end

      it 'returns a list for the extracted wacz files' do
        expect(described_class.wacz_file_list(cocina_model)).to eq ['WACZ-Test.wacz']
      end
    end

    context 'for the contentMetadata with no waczs or arcs or warcs inside' do
      let(:structural) do
        Cocina::Models::DROStructural.new(contains: [
                                            { type: Cocina::Models::FileSetType.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file1] } }
                                          ])
      end

      let(:file1) do
        Cocina::Models::File.new(type: Cocina::Models::ObjectType.file, externalIdentifier: '',
                                 label: '', filename: 'test.txt', version: 1,
                                 administrative: { shelve: false })
      end

      it 'returns an empty list for arc and warc files' do
        expect(described_class.warc_file_list(cocina_model)).to eq []
      end

      it 'returns an empty list for waczs' do
        expect(described_class.wacz_file_list(cocina_model)).to eq []
      end
    end

    context 'when the contentMetadata has dark archive shelve=no' do
      let(:structural) do
        Cocina::Models::DROStructural.new(contains: [
                                            { type: Cocina::Models::FileSetType.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file1] } },
                                            { type: Cocina::Models::FileSetType.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file2] } },
                                            { type: Cocina::Models::FileSetType.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file3] } },
                                            { type: Cocina::Models::FileSetType.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file4] } },
                                            { type: Cocina::Models::FileSetType.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file5] } }
                                          ])
      end
      let(:file1) do
        Cocina::Models::File.new(type: Cocina::Models::ObjectType.file, externalIdentifier: '',
                                 label: '', filename: 'WARC-Test.warc.gz', version: 1,
                                 administrative: { shelve: false })
      end
      let(:file2) do
        Cocina::Models::File.new(type: Cocina::Models::ObjectType.file, externalIdentifier: '',
                                 label: '', filename: 'ARC-Test.arc.gz', version: 1,
                                 administrative: { shelve: false })
      end
      let(:file3) do
        Cocina::Models::File.new(type: Cocina::Models::ObjectType.file, externalIdentifier: '',
                                 label: '', filename: 'test.txt', version: 1,
                                 administrative: { shelve: false })
      end
      let(:file4) do
        Cocina::Models::File.new(type: Cocina::Models::ObjectType.file, externalIdentifier: '',
                                 label: '', filename: 'ARC-Test2.arc.gz', version: 1,
                                 administrative: { shelve: false })
      end
      let(:file5) do
        Cocina::Models::File.new(type: Cocina::Models::ObjectType.file, externalIdentifier: '',
                                 label: '', filename: 'WACZ-Test.wacz', version: 1,
                                 administrative: { shelve: false })
      end

      it 'returns an empty list for arc and warc files' do
        expect(described_class.warc_file_list(cocina_model)).to eq []
      end

      it 'returns an empty list for wacz files' do
        expect(described_class.wacz_file_list(cocina_model)).to eq []
      end
    end
  end

  describe '.get_collection_id' do
    let(:druid_obj) { double(Cocina::Models::DRO) }

    it 'delegates to Dor::WasCrawl::Utilities' do
      expect(Dor::WasCrawl::Utilities).to receive(:get_collection_id).with(druid_obj).and_return('abc')
      expect(described_class.get_collection_id(druid_obj)).to eq 'abc'
    end
  end
end
