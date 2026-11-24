# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasCrawlPreassembly::EndWasCrawlPreassembly do
  describe '.initialize' do
    it 'initializes the robot with valid parameters' do
      robot = described_class.new
      expect(robot.instance_variable_get(:@workflow_name)).to eq('wasCrawlPreassemblyWF')
      expect(robot.instance_variable_get(:@process)).to eq('end-was-crawl-preassembly')
    end
  end

  describe '.perform' do
    let(:druid) { 'druid:ab123cd4567' }
    let(:object_client) { instance_double(Dor::Services::Client::Object, version: version_client) }
    let(:version_client) { instance_double(Dor::Services::Client::ObjectVersion, current: '1') }

    let(:process_response) { instance_double(Dor::Services::Response::Process, lane_id: 'low', context: {}) }
    let(:workflow_response) do
      instance_double(Dor::Services::Response::Workflow, process_for_recent_version: process_response)
    end
    let(:object_workflow) { instance_double(Dor::Services::Client::ObjectWorkflow, find: workflow_response) }

    before do
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
      allow(object_client).to receive(:workflow).with('wasCrawlPreassemblyWF').and_return(object_workflow)
    end

    it 'starts the accessionWF in the workflow lane' do
      allow(version_client).to receive(:close)
      robot = described_class.new
      test_perform(robot, druid)
      expect(version_client).to have_received(:close).with(lane_id: 'low', user_versions: nil)
    end
  end
end
