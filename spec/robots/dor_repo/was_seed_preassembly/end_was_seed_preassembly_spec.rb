# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasSeedPreassembly::EndWasSeedPreassembly do
  describe 'perform' do
    subject(:perform) { test_perform(instance, druid) }

    let(:druid) { 'druid:ab123cd4567' }
    let(:instance) { described_class.new }
    let(:object_client) { instance_double(Dor::Services::Client::Object, version: version_client) }
    let(:version_client) { instance_double(Dor::Services::Client::ObjectVersion, current: '1') }
    let(:process_response) { instance_double(Dor::Services::Response::Process, lane_id: 'high', context:) }
    let(:context) { {} }
    let(:workflow_response) do
      instance_double(Dor::Services::Response::Workflow, process_for_recent_version: process_response)
    end
    let(:object_workflow) { instance_double(Dor::Services::Client::ObjectWorkflow, find: workflow_response) }

    before do
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
      allow(object_client).to receive(:workflow).with('wasSeedPreassemblyWF').and_return(object_workflow)
      allow(version_client).to receive(:close)
    end

    context 'with new objects' do
      it 'starts accessioning in the workflow lane' do
        perform
        expect(version_client).to have_received(:close).with(lane_id: 'high', user_versions: nil)
      end
    end

    context 'when the workflow context has a user version mode' do
      let(:context) { { 'userVersions' => 'new' } }

      it 'closes the version with the user version mode' do
        perform
        expect(version_client).to have_received(:close).with(lane_id: 'high', user_versions: 'new')
      end
    end
  end
end
