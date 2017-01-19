require 'spec_helper'

describe Robots::DorRepo::WasCrawlPreassembly::EndWasCrawlPreassembly do
  describe '.initialize' do
    it 'initalizes the robot with valid parameters' do
      robot = Robots::DorRepo::WasCrawlPreassembly::EndWasCrawlPreassembly.new
      expect(robot.instance_variable_get(:@repo)).to eq('dor')
      expect(robot.instance_variable_get(:@workflow_name)).to eq('wasCrawlPreassemblyWF')
      expect(robot.instance_variable_get(:@step_name)).to eq('end-was-crawl-preassembly')
    end
  end

  describe '.perform' do
    it 'start the accessionWF on default lane' do
      Dor::Config.was_crawl.dedicated_lane = nil
      allow(Dor::WorkflowObject).to receive(:initial_workflow).with('accessionWF').and_return('')
      expect(Dor::WorkflowService).to receive(:create_workflow).with('dor', 'druid:ab123cd4567', 'accessionWF', '', {create_ds: true, lane_id: 'default'})
      robot = Robots::DorRepo::WasCrawlPreassembly::EndWasCrawlPreassembly.new
      robot.perform('druid:ab123cd4567')
    end
    it 'start the accessionWF on a non-default lane' do
      Dor::Config.was_crawl.dedicated_lane = 'NotDefault'
      allow(Dor::WorkflowObject).to receive(:initial_workflow).with('accessionWF').and_return('')
      expect(Dor::WorkflowService).to receive(:create_workflow).with('dor', 'druid:ab123cd4567', 'accessionWF', '', {create_ds: true, lane_id: 'NotDefault'})
      robot = Robots::DorRepo::WasCrawlPreassembly::EndWasCrawlPreassembly.new
      robot.perform('druid:ab123cd4567')
    end  end
end
