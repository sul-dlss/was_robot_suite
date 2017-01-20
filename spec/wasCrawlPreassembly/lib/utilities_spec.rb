require 'spec_helper'

describe Dor::WASCrawl::Utilities do
  let(:druid) { 'druid:aa111bb2222' }
  let(:druid_obj) { Dor.find(druid) }
  let(:collections) { double(ActiveFedora::Associations::CollectionProxy) }
  before do
    allow(Dor).to receive(:find).and_return(double(Dor::Item, id: druid))
  end
  context 'collections' do
    let(:collection_druid) { 'druid:cc333dd4444' }
    let(:collection) { double(Dor::Collection, id: collection_druid) }
    before do
      expect(druid_obj).to receive(:collections).and_return(collections)
    end
    it 'fetches a collection id' do
      expect(collections).to receive(:first).and_return(collection)
      expect(subject.class.get_collection_id(druid_obj)).to eq 'cc333dd4444'
    end
    it 'handles no collections' do
      expect(collections).to receive(:first).and_return(nil)
      expect(druid_obj).to receive(:id)
      expect { subject.class.get_collection_id(druid_obj) }.to raise_error(RuntimeError, /aa111bb2222 doesn't belong to a collection/)
    end
  end
  it 'dies if ActiveFedora API changes' do
    expect(druid_obj).to receive(:collections).and_return(nil)
    expect(druid_obj).to receive(:id)
    expect { subject.class.get_collection_id(druid_obj) }.to raise_error(RuntimeError, /aa111bb2222 doesn't belong to a collection/)
  end
end
