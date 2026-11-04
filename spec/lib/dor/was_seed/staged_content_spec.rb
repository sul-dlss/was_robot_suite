# frozen_string_literal: true

RSpec.describe Dor::WasSeed::StagedContent do
  subject(:staged_content) { described_class.new(druid: 'druid:bc123df4567', staging_path:) }

  let(:staging_path) { Dir.mktmpdir }
  let(:content_dir) { "#{staging_path}/bc/123/df/4567/bc123df4567/content" }

  after do
    FileUtils.rm_rf(staging_path)
  end

  describe '#jp2_path' do
    context 'when there is no content folder' do
      it 'returns nil' do
        expect(staged_content.jp2_path).to be_nil
      end
    end

    context 'when there is one jp2' do
      before do
        FileUtils.mkdir_p(content_dir)
        FileUtils.touch("#{content_dir}/custom.jp2")
      end

      it 'returns its path' do
        expect(staged_content.jp2_path).to eq "#{content_dir}/custom.jp2"
      end
    end

    context 'when the only jp2 is in a subfolder' do
      before do
        FileUtils.mkdir_p("#{content_dir}/images")
        FileUtils.touch("#{content_dir}/images/custom.jp2")
      end

      it 'returns nil' do
        expect(staged_content.jp2_path).to be_nil
      end
    end

    context 'when there is more than one jp2' do
      before do
        FileUtils.mkdir_p(content_dir)
        FileUtils.touch("#{content_dir}/b.jp2")
        FileUtils.touch("#{content_dir}/a.jp2")
      end

      it 'raises an error listing them' do
        expect { staged_content.jp2_path }.to raise_error(RuntimeError, /Expected at most one jp2 in .* but found 2: a.jp2, b.jp2/)
      end
    end
  end
end
