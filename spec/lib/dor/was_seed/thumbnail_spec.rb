# frozen_string_literal: true

RSpec.describe Dor::WasSeed::Thumbnail do
  subject(:thumbnail) { described_class.new(druid:, cocina_model:) }

  let(:druid) { 'druid:bc123df4567' }
  let(:cocina_model) { build(:dro, id: druid) }
  let(:staging_path) { Dir.mktmpdir }
  let(:content_dir) { "#{staging_path}/bc/123/df/4567/bc123df4567/content" }

  before do
    allow(Settings.was_seed).to receive(:staging_path).and_return(staging_path)
  end

  after do
    FileUtils.rm_rf(staging_path)
  end

  describe '#path' do
    before do
      FileUtils.mkdir_p(content_dir)
      FileUtils.touch("#{content_dir}/custom.jp2")
    end

    it 'returns the jp2 in the staging folder' do
      expect(thumbnail.path).to eq "#{content_dir}/custom.jp2"
    end
  end

  describe '#keep_existing?' do
    context 'when there is no jp2 and nothing in the structure' do
      it { is_expected.not_to be_keep_existing }
    end

    context 'when there is no jp2 and the structure has a published jp2' do
      let(:cocina_model) { with_jp2_structural(build(:dro, id: druid), publish: true) }

      it { is_expected.to be_keep_existing }
    end

    context 'when there is no jp2 and the structure has an unpublished jp2' do
      let(:cocina_model) { with_jp2_structural(build(:dro, id: druid), publish: false) }

      it { is_expected.not_to be_keep_existing }
    end

    context 'when there is a jp2 and the structure has a published jp2' do
      let(:cocina_model) { with_jp2_structural(build(:dro, id: druid), publish: true) }

      before do
        FileUtils.mkdir_p(content_dir)
        FileUtils.touch("#{content_dir}/new.jp2")
      end

      it { is_expected.not_to be_keep_existing }
    end
  end
end
