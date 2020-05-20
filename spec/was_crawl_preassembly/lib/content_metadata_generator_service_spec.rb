require 'spec_helper'

RSpec.describe Dor::WASCrawl::ContentMetadataGenerator do
  before(:all) do
    @staging_path = Pathname(File.dirname(__FILE__)).join('../fixtures/workspace')
    @extracted_metadata_xml_location = Pathname(File.dirname(__FILE__)).join('../fixtures/xml_extracted_metadata')
    @collection_id = 'test_collection'
    @crawl_id = 'test_crawl'
    generate_data_items
  end

  context Dor::WASCrawl::ContentMetadataGenerator, 'generate_metadata_output' do
    it 'should generate contentMetadata.xml with valid druid and input' do
      druid_id = 'druid:gh123gh1234'
      metadata_generator_service = generate_object(druid_id)
      metadata_generator_service.instance_variable_set(:@extracted_metadata_xml_location, @extracted_metadata_xml_location)
      allow(metadata_generator_service).to receive(:template_suffix).and_return('public')
      metadata_generator_service.generate_metadata_output

      expected_output_file = "#{@staging_path}/gh/123/gh/1234/gh123gh1234/metadata/contentMetadata.xml"
      actual_content_metadata = File.read(expected_output_file)
      expect(actual_content_metadata).to eq @expected_content_metadata
    end

    after(:each) do
      expected_output_file = "#{@staging_path}/gh/123/gh/1234/gh123gh1234/metadata/contentMetadata.xml"
      File.delete(expected_output_file)
    end
  end

  context Dor::WASCrawl::ContentMetadataGenerator, 'do_post_transform' do
    it 'should add the id to the root node' do
      druid_id = 'druid:gh123gh1234'
      metadata_generator_service = generate_object(druid_id)

      pre_transform_str = '<?xml version="1.0" ?><test_root><test_element/></test_root>'
      expected_post_transform_str = Nokogiri::XML('<?xml version="1.0" ?><test_root id="druid:gh123gh1234"><test_element/>')
      actual_post_transform_str = metadata_generator_service.do_post_transform(pre_transform_str)

      expect(actual_post_transform_str).to eq expected_post_transform_str.to_s
    end

    it 'should raise an error with an invalid xml input' do
      druid_id = 'druid:gh123gh1234'
      metadata_generator_service = generate_object(druid_id)

      pre_transform_invalid_str = '<?xml version="1.0" ?><test_root><test_element/>'
      expect { metadata_generator_service.do_post_transform(pre_transform_invalid_str) }.to raise_error(RuntimeError, /input string is not a valid xml file/)
    end
  end

  context Dor::WASCrawl::ContentMetadataGenerator, 'template_suffix' do
    let(:metadata_generator_service) { generate_object(druid_id) }
    let(:druid_id) { 'druid:gh123gh1234' }
    let(:apo_pid) { 'druid:dz123fg1234' }
    let(:object_client) { instance_double(Dor::Services::Client::Object, find: cocina_object) }
    let(:cocina_object) { instance_double(Cocina::Models::DRO, administrative: dro_administrative) }
    let(:dro_administrative) { instance_double(Cocina::Models::Administrative, hasAdminPolicy: apo_pid) }

    let(:apo_client) { instance_double(Dor::Services::Client::Object, find: cocina_apo) }
    let(:cocina_apo) { instance_double(Cocina::Models::AdminPolicy, administrative: apo_administrative) }
    let(:apo_administrative) { instance_double(Cocina::Models::AdminPolicyAdministrative, defaultObjectRights: xml) }

    before do
      allow(Dor::Services::Client).to receive(:object).with(druid_id).and_return(object_client)
      allow(Dor::Services::Client).to receive(:object).with(apo_pid).and_return(apo_client)
    end

    context 'when the access is dark' do
      let(:xml) do
        '<rightsMetadata> <access type= "discover">  <machine>   <world/>  </machine> </access> ' +
          '<access type= "read">  <machine>   <none/>  </machine> </access> <use> ' +
          '<human type= "useAndReproduction"/> <human type= "creativeCommons"/> ' +
          '<machine type= "creativeCommons"/> </use> <copyright>  <human/> </copyright></rightsMetadata>'
      end

      it 'returns dark for read/none access' do
        expect(metadata_generator_service.template_suffix).to eq('dark')
      end
    end

    context 'when the access is world' do
      let(:xml) do
        '<rightsMetadata> <access type= "discover">  <machine>   <world/>  </machine> </access> ' +
          '<access type= "read">  <machine>   <world/>  </machine> </access> <use> ' +
          '<human type= "useAndReproduction"/> <human type= "creativeCommons"/> ' +
          '<machine type= "creativeCommons"/> </use> <copyright>  <human/> </copyright></rightsMetadata>'
      end

      it 'returns public for read/world access' do
        expect(metadata_generator_service.template_suffix).to eq('public')
      end
    end
  end

  def generate_object(druid_id)
    metadata_generator_service = Dor::WASCrawl::ContentMetadataGenerator.new(@collection_id,
                                                                             @staging_path.to_s, druid_id)
    metadata_generator_service
  end

  def generate_data_items
    @expected_content_metadata = <<~EOF
      <?xml version="1.0"?>
      <contentMetadata type="file" stacks="/web-archiving-stacks/data/collections/" id="druid:gh123gh1234">
        <resource type="file" id="gh123gh1234_1">
          <file dataType="WARC" publish="no" shelve="yes" preserve="yes" id="WARC-Test.warc.gz" size="6608320" mimetype="application/octet-stream">
            <checksum type="MD5">c7edbde066e4697b3f2d823ac42c3692</checksum>
            <checksum type="SHA1">3a9f2ffac1497c70291d93a8bc86c1469547d8f8</checksum>
          </file>
        </resource>
        <resource type="file" id="gh123gh1234_2">
          <file dataType="ARC" publish="no" shelve="yes" preserve="yes" id="ARC-Test.arc.gz" size="87846905" mimetype="application/octet-stream">
            <checksum type="MD5">f05e6759eeebbed5e17266809872c9f3</checksum>
            <checksum type="SHA1">e4fd69c988b5abb5d082e4ec897a582d74dc2bbf</checksum>
          </file>
        </resource>
        <resource type="file" id="gh123gh1234_3">
          <file dataType="general" publish="no" shelve="no" preserve="yes" id="test.txt" size="4" mimetype="text/plain">
            <checksum type="MD5">e2fc714c4727ee9395f324cd2e7f331f</checksum>
            <checksum type="SHA1">81fe8bfe87576c3ecb22426f8e57847382917acf</checksum>
          </file>
        </resource>
      </contentMetadata>
    EOF
  end
end
