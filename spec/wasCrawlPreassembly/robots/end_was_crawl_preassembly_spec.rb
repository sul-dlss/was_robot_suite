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
    let(:xml) { '<xml/>' }

    before do
      allow(Dor::Services::Client).to receive_message_chain(:workflows, :initial).and_return(xml)
    end

    it 'start the accessionWF on default lane' do
      Dor::Config.was_crawl.dedicated_lane = nil
      expect(Dor::Services::Client).to receive_message_chain(:workflows, :initial).with(name: 'accessionWF')
      expect(Dor::WorkflowService).to receive(:create_workflow).with('dor', 'druid:ab123cd4567', 'accessionWF', xml, {create_ds: true, lane_id: 'default'})
      robot = Robots::DorRepo::WasCrawlPreassembly::EndWasCrawlPreassembly.new
      robot.perform('druid:ab123cd4567')
    end
    it 'start the accessionWF on a non-default lane' do
      Dor::Config.was_crawl.dedicated_lane = 'NotDefault'
      expect(Dor::Services::Client).to receive_message_chain(:workflows, :initial).with(name: 'accessionWF')
      expect(Dor::WorkflowService).to receive(:create_workflow).with('dor', 'druid:ab123cd4567', 'accessionWF', xml, {create_ds: true, lane_id: 'NotDefault'})
      robot = Robots::DorRepo::WasCrawlPreassembly::EndWasCrawlPreassembly.new
      robot.perform('druid:ab123cd4567')
    end  end
end
