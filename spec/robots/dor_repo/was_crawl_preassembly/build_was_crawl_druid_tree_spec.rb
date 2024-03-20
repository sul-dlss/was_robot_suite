# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasCrawlPreassembly::BuildWasCrawlDruidTree do
  describe '.initialize' do
    it 'initializes the robot with valid parameters' do
      robot = described_class.new
      expect(robot.instance_variable_get(:@workflow_name)).to eq('wasCrawlPreassemblyWF')
      expect(robot.instance_variable_get(:@process)).to eq('build-was-crawl-druid-tree')
    end
  end

  describe '.perform' do
    let(:druid) { 'druid:ab123cd4567' }
    let(:cocina_model) { instance_double(Cocina::Models::DRO, label: 'AIT_123') }
    let(:object_client) { instance_double(Dor::Services::Client::Object, find: cocina_model) }
    let(:temp_dir) { Dir.mktmpdir }
    let(:staging_path) { "#{temp_dir}/workspace" }
    let(:source_path) { "#{temp_dir}/source" }
    let(:crawl_path) { "#{source_path}/AIT_123" }

    before do
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
      allow(Settings.was_crawl).to receive_messages(staging_path:, source_path:)

      FileUtils.mkdir_p(crawl_path)
      FileUtils.cp('spec/was_crawl_preassembly/fixtures/workspace/test_crawl_object/WARC-Test.warc.gz', crawl_path)
      FileUtils.mkdir(staging_path)
    end

    after do
      FileUtils.rm_rf(temp_dir)
    end

    it 'copies the files to staging' do
      robot = described_class.new
      test_perform(robot, druid)
      expect(File.exist?(crawl_path)).to be false
      expect(File.exist?("#{staging_path}/ab/123/cd/4567/ab123cd4567/content/WARC-Test.warc.gz")).to be true
    end
  end
end
