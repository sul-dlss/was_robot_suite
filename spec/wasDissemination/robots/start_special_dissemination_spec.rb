require 'spec_helper'

RSpec.describe Robots::DorRepo::WasDissemination::StartSpecialDissemination do
  let(:druid_obj) { instance_double(Dor::Item, contentMetadata: contentMetadata) }
  let(:contentMetadata) { Dor::ContentMetadataDS }
  let(:druid) { 'druid:ab123cd4567' }
  subject(:robot) { described_class.new }

  describe '.initialize' do
    it 'initalizes the robot with valid parameters' do
      expect(robot.instance_variable_get(:@repo)).to eq('dor')
      expect(robot.instance_variable_get(:@workflow_name)).to eq('wasDisseminationWF')
      expect(robot.instance_variable_get(:@step_name)).to eq('start-special-dissemination')
    end
  end

  describe '.perform' do
    subject(:perform) { robot.perform(druid) }

    let(:version_client) { instance_double(Dor::Services::Client::ObjectVersion, current: '5') }
    let(:object_client) { instance_double(Dor::Services::Client::Object, version: version_client) }

    before do
      allow(Dor).to receive(:find).and_return(druid_obj)
      allow(Dor::Services::Client).to receive(:object).with(druid).and_return(object_client)
    end

    it 'does nothing for collection object' do
      allow(druid_obj).to receive_message_chain('identityMetadata.objectType').and_return(['collection'])

      expect(robot.workflow_service).not_to receive(:create_workflow_by_name)

      perform
    end

    it 'initializes wasSeedDisseminationWF for webarchive-seed item' do
      allow(druid_obj).to receive_message_chain('identityMetadata.objectType').and_return(['item'])
      allow(contentMetadata).to receive(:contentType).and_return(['webarchive-seed'])
      expect(robot.workflow_service).to receive(:create_workflow_by_name).with(druid, 'wasSeedDisseminationWF', version: 5)
      perform
    end

    it 'initializes wasCrawlDisseminationWF for crawl item' do
      allow(druid_obj).to receive_message_chain('identityMetadata.objectType').and_return(['item'])
      allow(contentMetadata).to receive(:contentType).and_return(['file'])
      expect(robot.workflow_service).to receive(:create_workflow_by_name).with(druid, 'wasCrawlDisseminationWF', version: 5)
      perform
    end
  end
end
