require 'spec_helper'

describe Robots::DorRepo::WasSeedPreassembly::EndWasSeedPreassembly do
  describe 'perform' do
    it 'should initialize accessionWF for the new objects' do
      druid_obj = double('druid_obj')
      expect(druid_obj).to receive(:initialize_workflow).with("accessionWF")
      allow(Dor::Item).to receive(:find).and_return(druid_obj)
    
      allow(Dor::WorkflowService).to receive(:get_workflow_status)
      end_was_robots = Robots::DorRepo::WasSeedPreassembly::EndWasSeedPreassembly.new 
      end_was_robots.perform('druid:ab123cd4567')
      
    end
    it 'should re-version the object already accessioned objects' do
      druid_obj = double('druid_obj')
      expect(druid_obj).to receive(:open_new_version)
      expect(druid_obj).to receive(:close_version).with( {:description=>'Updating the seed object through wasSeedPreassemblyWF', :significance=>'Major'})
      
      allow(Dor::Item).to receive(:find).and_return(druid_obj)
      allow(Dor::WorkflowService).to receive(:get_workflow_status).and_return('completed')
      
      end_was_robots = Robots::DorRepo::WasSeedPreassembly::EndWasSeedPreassembly.new 
      end_was_robots.perform('druid:ab123cd4567')
    end   
    it 'should issue an error for the objects that are under accessioning' do
      druid_obj = double('druid_obj')
      
      allow(Dor::Item).to receive(:find).and_return(druid_obj)
      allow(Dor::WorkflowService).to receive(:get_workflow_status).with('dor', 'druid:ab123cd4567' ,'accessionWF', 'start-accession').and_return('completed')
      allow(Dor::WorkflowService).to receive(:get_workflow_status).with('dor', 'druid:ab123cd4567', 'accessionWF', 'end-accession').and_return(nil)

      end_was_robots = Robots::DorRepo::WasSeedPreassembly::EndWasSeedPreassembly.new 
      expect{end_was_robots.perform('druid:ab123cd4567')}.to raise_error('Druid object druid:ab123cd4567 is still in accessioning, reset the end-was-seed-preassembly after accessioing completion')
    end   
    it 'should issue an error for the objects have unknown status' do
      druid_obj = double('druid_obj')
      
      allow(Dor::Item).to receive(:find).and_return(druid_obj)
      allow(Dor::WorkflowService).to receive(:get_workflow_status).with('dor', 'druid:ab123cd4567' ,'accessionWF', 'end-accession').and_return('completed')
      allow(Dor::WorkflowService).to receive(:get_workflow_status).with('dor', 'druid:ab123cd4567', 'accessionWF', 'start-accession').and_return(nil)

      end_was_robots = Robots::DorRepo::WasSeedPreassembly::EndWasSeedPreassembly.new 
      expect{end_was_robots.perform('druid:ab123cd4567')}.to raise_error('Druid object druid:ab123cd4567 is unknown status')
    end     
  end
end