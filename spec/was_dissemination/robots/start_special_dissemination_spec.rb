require 'spec_helper'

RSpec.describe Robots::DorRepo::WasDissemination::StartSpecialDissemination do
  let(:druid_obj) { instance_double(Dor::Item, contentMetadata: contentMetadata) }
  let(:contentMetadata) { Dor::ContentMetadataDS }
  let(:druid) { 'druid:ab123cd4567' }
  subject(:robot) { described_class.new }

  describe '.initialize' do
    it 'initalizes the robot with valid parameters' do
      expect(robot.instance_variable_get(:@workflow_name)).to eq('wasDisseminationWF')
      expect(robot.instance_variable_get(:@process)).to eq('start-special-dissemination')
    end
  end

  describe '.perform' do
    subject(:perform) { robot.perform(druid) }
    let(:version_client) { instance_double(Dor::Services::Client::ObjectVersion, current: '1') }
    let(:object_client) { instance_double(Dor::Services::Client::Object, version: version_client) }
    let(:workflow_service) { instance_double(Dor::Workflow::Client, create_workflow_by_name: true) }

    before do
      allow(Dor).to receive(:find).and_return(druid_obj)
      allow(Dor::Services::Client).to receive(:object).with(druid).and_return(object_client)
      allow(WorkflowClientFactory).to receive(:build).and_return(workflow_service)
      allow(druid_obj).to receive_message_chain('identityMetadata.objectType').and_return([object_type])
    end

    context 'when the type is collection' do
      let(:object_type) { 'collection' }

      it 'does nothing for collection object' do
        perform
        expect(workflow_service).not_to have_received(:create_workflow_by_name)
      end
    end

    context 'when the object type is item' do
      let(:object_type) { 'item' }

      before do
        allow(contentMetadata).to receive(:contentType).and_return([content_type])
      end

      context 'when the contentType is webarchive-seed' do
        let(:content_type) { 'webarchive-seed' }

        it 'initializes wasSeedDisseminationWF for the webarchive-seed item' do
          perform
          expect(workflow_service).to have_received(:create_workflow_by_name).with(druid, 'wasSeedDisseminationWF', version: '1')
        end
      end

      context 'when the contentType is file (crawl item)' do
        let(:content_type) { 'file' }

        it 'initializes wasCrawlDisseminationWF for the crawl item' do
          perform
          expect(workflow_service).to have_received(:create_workflow_by_name).with(druid, 'wasCrawlDisseminationWF', version: '1')
        end
      end
    end
  end
end
