# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasDissemination::StartSpecialDissemination do
  subject(:robot) { described_class.new }

  let(:druid) { 'druid:ab123cd4567' }

  describe '.initialize' do
    it 'initalizes the robot with valid parameters' do
      expect(robot.instance_variable_get(:@workflow_name)).to eq('wasDisseminationWF')
      expect(robot.instance_variable_get(:@process)).to eq('start-special-dissemination')
    end
  end

  describe '.perform' do
    subject(:perform) { test_perform(robot, druid) }

    let(:object_client) { instance_double(Dor::Services::Client::Object, find: item) }
    let(:workflow_service) { instance_double(Dor::Workflow::Client, create_workflow_by_name: true) }

    before do
      allow(Dor::Services::Client).to receive(:object).with(druid).and_return(object_client)
      allow(LyberCore::WorkflowClientFactory).to receive(:build).and_return(workflow_service)
    end

    context 'when the type is collection' do
      let(:item) { instance_double(Cocina::Models::Collection, dro?: false) }

      it 'does nothing for collection object' do
        perform
        expect(workflow_service).not_to have_received(:create_workflow_by_name)
      end
    end

    context 'when the object type is item' do
      let(:item) { instance_double(Cocina::Models::DRO, version: '1', dro?: true, type:) }

      context 'when the type is webarchive-seed' do
        let(:type) { Cocina::Models::ObjectType.webarchive_seed }

        it 'initializes wasSeedDisseminationWF for the webarchive-seed item' do
          expect(perform.status).to eq 'skipped'
          expect(workflow_service).not_to have_received(:create_workflow_by_name)
        end
      end

      context 'when the type is object (crawl item)' do
        let(:type) { Cocina::Models::ObjectType.webarchive_binary }

        it 'initializes wasCrawlDisseminationWF for the crawl item' do
          perform
          expect(workflow_service).to have_received(:create_workflow_by_name).with(druid, 'wasCrawlDisseminationWF', version: '1')
        end
      end
    end
  end
end
