require 'spec_helper'

describe Robots::DorRepo::WasCrawlPreassembly::EndWasCrawlPreassembly do
  describe '.initialize' do
    it 'initializes the robot with valid parameters' do
      robot = Robots::DorRepo::WasCrawlPreassembly::EndWasCrawlPreassembly.new
      expect(robot.instance_variable_get(:@repo)).to eq('dor')
      expect(robot.instance_variable_get(:@workflow_name)).to eq('wasCrawlPreassemblyWF')
      expect(robot.instance_variable_get(:@step_name)).to eq('end-was-crawl-preassembly')
    end
  end

  describe '.perform' do
    let(:druid) { 'druid:ab123cd4567' }
    let(:workflow_client) { instance_double(Dor::Workflow::Client) }
    let(:workflow_name) { 'accessionWF' }
    let(:object_client) { instance_double(Dor::Services::Client::Object, version: version_client) }
    let(:version_client) { instance_double(Dor::Services::Client::ObjectVersion, current: '1') }

    before do
      allow(Dor::Config.workflow).to receive(:client).and_return(workflow_client)
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
    end

    it 'starts the accessionWF on default lane' do
      allow(workflow_client).to receive(:create_workflow_by_name)
      robot = Robots::DorRepo::WasCrawlPreassembly::EndWasCrawlPreassembly.new
      robot.perform(druid)
      expect(workflow_client).to have_received(:create_workflow_by_name)
        .with(druid, workflow_name, lane_id: 'default', version: '1')
    end

    it 'starts the accessionWF on a non-default lane' do
      Settings.was_crawl.dedicated_lane = 'NotDefault'
      allow(workflow_client).to receive(:create_workflow_by_name)
      robot = Robots::DorRepo::WasCrawlPreassembly::EndWasCrawlPreassembly.new
      robot.perform(druid)
      expect(workflow_client).to have_received(:create_workflow_by_name)
        .with(druid, workflow_name, lane_id: 'NotDefault', version: '1')
    end
  end
end
