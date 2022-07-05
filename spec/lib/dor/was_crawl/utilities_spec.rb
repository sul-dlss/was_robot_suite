# frozen_string_literal: true

RSpec.describe Dor::WasCrawl::Utilities do
  let(:druid) { 'druid:aa111bb2222' }
  let(:collection_druid) { 'druid:cc333dd4444' }

  let(:cocina_model) do
    instance_double(Cocina::Models::DRO, externalIdentifier: druid, structural: structural)
  end

  context 'when the object belongs to a collection' do
    let(:structural) { instance_double(Cocina::Models::DROStructural, isMemberOf: [collection_druid]) }

    it 'fetches a collection id' do
      expect(described_class.get_collection_id(cocina_model)).to eq 'cc333dd4444'
    end
  end

  context 'when the object does not belong to a collection' do
    let(:structural) { instance_double(Cocina::Models::DROStructural, isMemberOf: []) }

    it 'raises an error' do
      expect { described_class.get_collection_id(cocina_model) }.to raise_error(RuntimeError, /aa111bb2222 doesn't belong to a collection/)
    end
  end
end
