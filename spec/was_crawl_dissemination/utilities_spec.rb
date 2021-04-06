require 'spec_helper'
require 'was_crawl_dissemination/utilities'

RSpec.describe Dor::WASCrawl::Dissemination::Utilities do
  context '.run_sys_cmd' do
    it 'should return nothing with succesful command' do
      Dor::WASCrawl::Dissemination::Utilities.run_sys_cmd('ls', '')
    end
    it 'should raise an error with wrong command' do
      expect { Dor::WASCrawl::Dissemination::Utilities.run_sys_cmd('lss', '') }.to raise_error StandardError
    end
  end

  context '.warc_file_list' do
    let(:fs_structural) { instance_double(Cocina::Models::FileSetStructural, contains: files) }
    let(:fileset) { instance_double(Cocina::Models::FileSet, structural: fs_structural) }

    let(:cocina_model) { instance_double(Cocina::Models::DRO, structural: structural) }
    let(:file_list) { Dor::WASCrawl::Dissemination::Utilities.warc_file_list(cocina_model) }

    context 'with 4 files' do
      let(:structural) do
        Cocina::Models::DROStructural.new(contains: [
                                            { type: Cocina::Models::Vocab::Resources.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file1] } },
                                            { type: Cocina::Models::Vocab::Resources.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file2] } },
                                            { type: Cocina::Models::Vocab::Resources.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file3] } },
                                            { type: Cocina::Models::Vocab::Resources.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file4] } }
                                          ])
      end
      let(:file1) do
        Cocina::Models::File.new(type: Cocina::Models::Vocab.file, externalIdentifier: '',
                                 label: '', filename: 'WARC-Test.warc.gz', version: 1,
                                 administrative: { shelve: true })
      end
      let(:file2) do
        Cocina::Models::File.new(type: Cocina::Models::Vocab.file, externalIdentifier: '',
                                 label: '', filename: 'ARC-Test.arc.gz', version: 1,
                                 administrative: { shelve: true })
      end
      let(:file3) do
        Cocina::Models::File.new(type: Cocina::Models::Vocab.file, externalIdentifier: '',
                                 label: '', filename: 'test.txt', version: 1,
                                 administrative: { shelve: false })
      end
      let(:file4) do
        Cocina::Models::File.new(type: Cocina::Models::Vocab.file, externalIdentifier: '',
                                 label: '', filename: 'ARC-Test2.arc.gz', version: 1,
                                 administrative: { shelve: false })
      end

      it 'returns a list for the extrcted arc and warc files' do
        expect(file_list.length).to eq(2)
      end
    end

    context 'for the contentMetadata with no arcs or warcs inside' do
      let(:structural) do
        Cocina::Models::DROStructural.new(contains: [
                                            { type: Cocina::Models::Vocab::Resources.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file1] } }
                                          ])
      end

      let(:file1) do
        Cocina::Models::File.new(type: Cocina::Models::Vocab.file, externalIdentifier: '',
                                 label: '', filename: 'test.txt', version: 1,
                                 administrative: { shelve: false })
      end

      it 'returns an empty list' do
        expect(file_list).to eq []
      end
    end

    context 'when the contentMetadata has dark archive shelve=no' do
      let(:structural) do
        Cocina::Models::DROStructural.new(contains: [
                                            { type: Cocina::Models::Vocab::Resources.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file1] } },
                                            { type: Cocina::Models::Vocab::Resources.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file2] } },
                                            { type: Cocina::Models::Vocab::Resources.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file3] } },
                                            { type: Cocina::Models::Vocab::Resources.file, externalIdentifier: '', label: '', version: 1, structural: { contains: [file4] } }
                                          ])
      end
      let(:file1) do
        Cocina::Models::File.new(type: Cocina::Models::Vocab.file, externalIdentifier: '',
                                 label: '', filename: 'WARC-Test.warc.gz', version: 1,
                                 administrative: { shelve: false })
      end
      let(:file2) do
        Cocina::Models::File.new(type: Cocina::Models::Vocab.file, externalIdentifier: '',
                                 label: '', filename: 'ARC-Test.arc.gz', version: 1,
                                 administrative: { shelve: false })
      end
      let(:file3) do
        Cocina::Models::File.new(type: Cocina::Models::Vocab.file, externalIdentifier: '',
                                 label: '', filename: 'test.txt', version: 1,
                                 administrative: { shelve: false })
      end
      let(:file4) do
        Cocina::Models::File.new(type: Cocina::Models::Vocab.file, externalIdentifier: '',
                                 label: '', filename: 'ARC-Test2.arc.gz', version: 1,
                                 administrative: { shelve: false })
      end

      it 'returns an empty list' do
        expect(file_list).to eq []
      end
    end
  end

  context '.get_collection_id' do
    let(:druid_obj) { double(Cocina::Models::DRO) }

    it 'delegates to Dor::WASCrawl::Utilities' do
      expect(Dor::WASCrawl::Utilities).to receive(:get_collection_id).with(druid_obj).and_return('abc')
      expect(described_class.get_collection_id(druid_obj)).to eq 'abc'
    end
  end
end
