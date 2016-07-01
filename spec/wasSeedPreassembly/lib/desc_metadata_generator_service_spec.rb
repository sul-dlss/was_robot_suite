require 'spec_helper'
require 'was_seed_preassembly/desc_metadata_generator_service'

describe Dor::WASSeed::DescMetadataGenerator do
  before :all do
    @fixtures = 'spec/wasSeedPreassembly/fixtures/'
  end

  describe '.generate_metadata_output' do
    it 'generates descMetadata with valid source xml with AIT source' do
      druid_id = 'druid:aa111aa1111'

      metadata_generator_service = Dor::WASSeed::DescMetadataGenerator.new("#{@fixtures}workspace", druid_id)
      metadata_generator_service.generate_metadata_output

      actual_output_file = "#{@fixtures}workspace/aa/111/aa/1111/aa111aa1111/metadata/descMetadata.xml"
      actual_desc_metadata = File.read(actual_output_file)
      expected_desc_metadata = File.read("#{@fixtures}metadata/descMetadata_aa111aa1111.xml")

      expect(File.exist?(actual_output_file)).to be true
      expect(actual_desc_metadata).to eq(expected_desc_metadata)
    end
  end
end
