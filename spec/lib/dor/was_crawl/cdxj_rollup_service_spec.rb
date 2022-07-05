# frozen_string_literal: true

RSpec.describe Dor::WasCrawl::CdxjRollupService do
  describe '#rollup' do
    subject(:rollup_service) { described_class.new(level, index_dir) }

    let(:index_dir) { Pathname.new("tmp/cdxj") }
    let(:main_file) { "#{index_dir}/level0.cdxj" }
    let(:main_file1) { "#{index_dir}/level1.cdxj" }
    let(:level) { 0 }

    before do
      FileUtils.mkdir_p index_dir
      File.write(main_file, "AG\nBG\nCG")
      File.write(main_file1, "AA\nBG\nBH\nCI")
    end

    after do
      FileUtils.rm_r index_dir
    end

    it 'rolls up level0 into level1' do
      rollup_service.rollup
      expect(File.read(main_file1)).to eq 'AA
AG
BG
BH
CG
CI
'
      expect(File.read(main_file)).to be_empty
    end
  end
end
