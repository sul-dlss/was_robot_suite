require 'spec_helper'

RSpec.describe Robots::DorRepo::WasSeedPreassembly::EndWasSeedPreassembly do
  describe 'perform' do
    let(:druid) { 'druid:ab123cd4567' }
    let(:instance) { described_class.new }
    let(:version_client) { instance_double(Dor::Services::Client::ObjectVersion, current: '1') }
    let(:object_client) { instance_double(Dor::Services::Client::Object, version: version_client) }

    subject(:perform) { instance.perform(druid) }

    before do
      allow(Dor::Services::Client).to receive(:object).with(druid).and_return(object_client)
      allow(WorkflowClientFactory).to receive(:build).and_return(wf_client)
    end

    context 'for new objects' do
      let(:wf_client) { instance_double(Dor::Workflow::Client, workflow_status: nil) }

      it 'initializes accessionWF' do
        allow(instance.workflow_service).to receive(:create_workflow_by_name)
        perform
        expect(instance.workflow_service).to have_received(:create_workflow_by_name).with(druid, 'accessionWF', version: '1')
      end
    end

    context 'for already accessioned objects' do
      let(:wf_client) { instance_double(Dor::Workflow::Client, workflow_status: 'completed') }

      it 're-versions the object' do
        expect(version_client).to receive(:open)
        expect(version_client).to receive(:close).with(description: 'Updating the seed object through wasSeedPreassemblyWF', significance: 'Major')
        perform
      end
    end

    context 'for the objects that are under accessioning' do
      let(:wf_client) { instance_double(Dor::Workflow::Client) }
      before do
        allow(wf_client).to receive(:workflow_status).with('dor', 'druid:ab123cd4567', 'accessionWF', 'start-accession').and_return('completed')
        allow(wf_client).to receive(:workflow_status).with('dor', 'druid:ab123cd4567', 'accessionWF', 'end-accession').and_return(nil)
      end

      it 'issues an error' do
        expect { perform }.to raise_error('Druid object druid:ab123cd4567 is still in accessioning, reset the end-was-seed-preassembly after accessioning completion')
      end
    end

    context 'for the objects with unknown status' do
      let(:wf_client) { instance_double(Dor::Workflow::Client) }
      before do
        allow(wf_client).to receive(:workflow_status).with('dor', 'druid:ab123cd4567', 'accessionWF', 'start-accession').and_return(nil)
        allow(wf_client).to receive(:workflow_status).with('dor', 'druid:ab123cd4567', 'accessionWF', 'end-accession').and_return('completed')
      end

      it 'issues an error' do
        expect { perform }.to raise_error('Druid object druid:ab123cd4567 is unknown status')
      end
    end
  end
end
