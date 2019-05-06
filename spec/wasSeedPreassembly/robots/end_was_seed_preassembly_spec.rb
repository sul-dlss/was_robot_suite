require 'spec_helper'

RSpec.describe Robots::DorRepo::WasSeedPreassembly::EndWasSeedPreassembly do
  describe 'perform' do
    let(:druid) { 'druid:ab123cd4567' }
    let(:service) { instance_double(Dor::Services::Client::Object) }
    let(:item) { instance_double(Dor::Item) }
    let(:instance) { described_class.new }

    subject(:perform) { instance.perform(druid) }

    before do
      allow(Dor::Services::Client).to receive(:object).with(druid).and_return(service)
      allow(Dor).to receive(:find).and_return(item)
    end

    it 'initializes accessionWF for the new objects' do
      expect(item).to receive(:initialize_workflow).with('accessionWF')
      allow(Dor::WorkflowService).to receive(:workflow_status)
      perform
    end

    it 're-versions the object already accessioned objects' do
      expect(service).to receive(:open_new_version)
      expect(service).to receive(:close_version).with(description: 'Updating the seed object through wasSeedPreassemblyWF', significance: 'Major')
      allow(Dor::WorkflowService).to receive(:workflow_status).and_return('completed')
      perform
    end

    it 'issues an error for the objects that are under accessioning' do
      allow(Dor::WorkflowService).to receive(:workflow_status).with('dor', 'druid:ab123cd4567', 'accessionWF', 'start-accession').and_return('completed')
      allow(Dor::WorkflowService).to receive(:workflow_status).with('dor', 'druid:ab123cd4567', 'accessionWF', 'end-accession').and_return(nil)
      expect { perform }.to raise_error('Druid object druid:ab123cd4567 is still in accessioning, reset the end-was-seed-preassembly after accessioning completion')
    end

    it 'issues an error for the objects have unknown status' do
      allow(Dor::WorkflowService).to receive(:workflow_status).with('dor', 'druid:ab123cd4567', 'accessionWF', 'end-accession').and_return('completed')
      allow(Dor::WorkflowService).to receive(:workflow_status).with('dor', 'druid:ab123cd4567', 'accessionWF', 'start-accession').and_return(nil)
      expect { perform }.to raise_error('Druid object druid:ab123cd4567 is unknown status')
    end
  end
end
