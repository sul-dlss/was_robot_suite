# frozen_string_literal: true

RSpec.describe Dor::WasSeed::ContentMetadataGenerator do
  let(:expected_thumbnail_xml) { '<image><md5>cecab42610cefd7f8ba80c8505a0f95f</md5><sha1>c78e5e8e8ca02c6fffa9169b0e9e4df908675fdc</sha1><size>228709</size><width>1000</width><height>1215</height></image>' }
  let(:expected_item_xml_ng) { Nokogiri::XML("<item><druid>druid:aa111aa1111</druid>#{expected_thumbnail_xml}</item>") }

  describe '#generate_metadata_output' do
    let(:druid_id) { 'druid:gh123gh1234' }
    let(:workspace) { 'spec/was_seed_preassembly/fixtures/workspace' }
    let(:extracted_location) { 'bar' }
    let(:metadata_generator_service) { described_class.new(workspace, druid_id, extracted_location) }
    let(:expected_xml) do
      <<~XML
        <?xml version="1.0"?>
        <contentMetadata type="webarchive-seed" id="druid:gh123gh1234">
          <resource type="image" sequence="1" id="gh123gh1234_1">
            <file preserve="no" publish="yes" shelve="yes" mimetype="image/jp2" id="thumbnail.jp2" size="228709">
              <checksum type="md5">cecab42610cefd7f8ba80c8505a0f95f</checksum>
              <checksum type="sha1">c78e5e8e8ca02c6fffa9169b0e9e4df908675fdc</checksum>
              <imageData width="1000" height="1215"/>
            </file>
          </resource>
        </contentMetadata>
      XML
    end
    let(:stub_exif) { double(MiniExiftool, MIMEType: 'image/jp2', imagewidth: 1000, imageheight: 1215) }

    before do
      path = "#{workspace}/gh/123/gh/1234/gh123gh1234/content"
      FileUtils.mkdir_p(path)
      FileUtils.cp('spec/was_seed_preassembly/fixtures/thumbnail_files/thumbnail.jp2', path)
      allow(MiniExiftool).to receive(:new).and_return(stub_exif)
    end

    it 'generates contentMetadata file for a druid and valid thumbnail' do
      metadata_generator_service.generate_metadata_output

      expected_output_file = "#{workspace}/gh/123/gh/1234/gh123gh1234/metadata/contentMetadata.xml"
      actual_content_metadata = File.read(expected_output_file)
      expect(actual_content_metadata).to be_equivalent_to(expected_xml)
    end
  end

  describe '#ng_doc' do
    let(:described_class_instance) { described_class.new('', 'druid:aa111aa1111') }
    let(:expected_item_empty_ng) { Nokogiri::XML('<item><druid>druid:aa111aa1111</druid></item>') }

    it 'returns a complete xml element for druid and an image xml element' do
      actual_xml_element = described_class_instance.send(:ng_doc, expected_thumbnail_xml)
      expect(actual_xml_element).to be_equivalent_to(expected_item_xml_ng)
    end

    it 'returns a basic xml element for a druid and empty xml element' do
      actual_xml_element =  described_class_instance.send(:ng_doc, '')
      expect(actual_xml_element).to be_equivalent_to(expected_item_empty_ng)
    end

    it 'returns a basic xml element for a druid and missing/nil xml element' do
      actual_xml_element =  described_class_instance.send(:ng_doc)
      expect(actual_xml_element).to be_equivalent_to(expected_item_empty_ng)
    end
  end

  describe '#create_thumbnail_xml_element' do
    let(:fixture_path) { 'spec/was_seed_preassembly/fixtures' }

    it 'returns valid xml element for a thumbnail image' do
      thumbnail_file_location = "#{fixture_path}/thumbnail_files/thumbnail.jp2"
      actual_xml_element = described_class.new('', '').send(:create_thumbnail_xml_element, thumbnail_file_location)
      expect(actual_xml_element).to be_equivalent_to(expected_thumbnail_xml)
    end

    it 'returns empty string for non-existing images' do
      thumbnail_file_location = "#{fixture_path}/thumbnail_files/not_there.jpeg"
      actual_xml_element = described_class.new('', '').send(:create_thumbnail_xml_element, thumbnail_file_location)
      expect(actual_xml_element).to eq('')
    end

    it 'returns empty string for nil location string' do
      actual_xml_element = described_class.new('', '').send(:create_thumbnail_xml_element, nil)
      expect(actual_xml_element).to eq('')
    end

    it 'raises an exception for reading an empty image' do
      # TODO: ? This test case should be fixed with adding an empty image
      thumbnail_file_location = "#{fixture_path}/thumbnail_files/thumbnail_empty.jpeg"
      expect { described_class.new.send(:create_thumbnail_xml_element, thumbnail_file_location) }.to raise_error StandardError
    end

    it 'raises an error for reading an invalid image' do
      thumbnail_file_location = "#{fixture_path}/thumbnail_files/thumbnail_text.jpeg"
      expect { described_class.new.send(:create_thumbnail_xml_element, thumbnail_file_location) }.to raise_error StandardError
    end
  end

  # this method is in MetadataGenerator
  describe '#transform_xml_using_xslt' do
    let(:expected_content_metadata) do
      '<contentMetadata type="webarchive-seed" id="druid:aa111aa1111">
 <resource type="image" sequence="1" id="aa111aa1111_1">
   <file preserve="no" publish="yes" shelve="yes" mimetype="image/jp2" id="thumbnail.jp2" size="228709">
     <checksum type="md5">cecab42610cefd7f8ba80c8505a0f95f</checksum>
     <checksum type="sha1">c78e5e8e8ca02c6fffa9169b0e9e4df908675fdc</checksum>
     <imageData width="1000" height="1215"/>
   </file>
 </resource>
</contentMetadata>'
    end

    it 'transforms the xml to content metadata data format using XSLT' do
      xslt_template = File.read(Pathname(File.dirname(__FILE__)).join('../../../../template/wasSeedPreassembly/contentMetadata.xslt'))
      actual_content_metadata = described_class.new('', '').transform_xml_using_xslt(expected_item_xml_ng, xslt_template)
      expect(actual_content_metadata).to be_equivalent_to(expected_content_metadata)
    end
  end
end
