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
    let(:workflow_client) { instance_double(Dor::Workflow::Client) }
    let(:workflow_name) { 'accessionWF' }
    let(:object_client) { instance_double(Dor::Services::Client::Object, version: version_client) }
    let(:version_client) { instance_double(Dor::Services::Client::ObjectVersion, current: '1') }

    before do
      allow(LyberCore::WorkflowClientFactory).to receive(:build).and_return(workflow_client)
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
    end

    it 'starts the accessionWF' do
      allow(workflow_client).to receive(:create_workflow_by_name)
      robot = described_class.new
      test_perform(robot, druid)
      expect(workflow_client).to have_received(:create_workflow_by_name)
        .with(druid, workflow_name, version: '1')
    end
  end
end
