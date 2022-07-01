# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robots::DorRepo::WasCrawlDissemination::CdxjMerge do
  subject(:robot) { described_class.new }

  describe '.perform' do
    subject(:perform) { robot.perform(druid) }

    let(:druid) { 'druid:dd116zh0343' }
    let(:index_dir) { "tmp/cdxj" }
    let(:working_dir) { "tmp/#{druid}" }
    let(:main_file) { "#{index_dir}/level0.cdxj" }
    let(:working_file1) { "#{working_dir}/index1.cdxj" }
    let(:working_file2) { "#{working_dir}/index2.cdxj" }

    before do
      FileUtils.mkdir_p index_dir
      FileUtils.mkdir_p working_dir

      File.write(main_file, "AG\nBG\nCG")
      File.write(working_file1, "AA\nBH\nCI")
      File.write(working_file2, "AB\nBA\nCH")
    end

    after do
      FileUtils.rm_r working_dir
      FileUtils.rm_r index_dir
    end

    it 'runs the cdxj-merge' do
      perform
      expect(File.read(main_file)).to eq 'AA
AB
AG
BA
BG
BH
CG
CH
CI
'
    end
  end
end
