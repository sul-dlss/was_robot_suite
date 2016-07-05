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
    context 'generic source' do
      context 'xsl tranform' do
        let(:collection_id) { 'druid:mc744qd2082' }
        let(:seed_uri) { 'http://www.frontnational.com/?post_type=works' }
        let(:transformed_result) do
          source_xml = <<-XML
            <item>
              <druid_id>druid:oo000oo0000</druid_id>
              <collection_id>#{collection_id}</collection_id>
              <source_id>sul:Generic-source-id</source_id>
              <uri>#{seed_uri}</uri>
              <source>G</source>
              <embargo>false</embargo>
              <source_xml/>
            </item>
            XML
          desc_md_generator = Dor::WASSeed::DescMetadataGenerator.new('', 'druid:xx')
          xsl_xml = desc_md_generator.read_template('descMetadata_G')
          desc_md_generator.transform_xml_using_xslt(Nokogiri::XML(source_xml), xsl_xml)
        end
        require 'stanford-mods' # comes with dor-services gem
        let(:smods_rec) do
          smods_rec = Stanford::Mods::Record.new
          smods_rec.from_str(transformed_result)
          smods_rec
        end
        context 'results in MODS with' do
          it '<title> containing URI' do
            expect(smods_rec.title_info.title.text).to end_with seed_uri
          end
          it '<note> with displayLabel "Original site" of URI' do
            expect(smods_rec.note.text).to eq seed_uri
            expect(smods_rec.note.displayLabel).to eq ['Original site']
          end
          it '<location> with swap URL' do
            # test doesn't pass with location, needs _location ... stanford-mods bug
            # fixed in v2.2.0, but dor-services pinned to 1.5.3
            expect(smods_rec._location.url.text).to match %r{^https://swap.stanford.edu/*/}
            expect(smods_rec._location.url.text).to end_with seed_uri
            expect(smods_rec._location.displayLabel).to eq ['Archived site']
          end
          context 'constant values' do
            it '<typeOfResource> of text' do
              expect(smods_rec.typeOfResource.text).to eq 'text'
            end
            it '<genre> of "archived website"' do
              expect(smods_rec.genre.text).to eq 'archived website'
              expect(smods_rec.genre.authority).to eq ['local']
            end
            it '<physicalDescription> for WARC file' do
              expect(smods_rec.physical_description.form.text).to eq 'electronic'
              expect(smods_rec.physical_description.form.authority).to eq ['marcform']
              expect(smods_rec.physical_description.internetMediaType.text).to eq 'text/html'
              expect(smods_rec.physical_description.digitalOrigin.text).to eq 'born digital'
            end
            it '<recordInfo>' do
              expect(smods_rec.record_info.languageOfCataloging.languageTerm.text).to eq 'eng'
              expect(smods_rec.record_info.languageOfCataloging.languageTerm.type_at).to eq ['code']
              expect(smods_rec.record_info.languageOfCataloging.languageTerm.authority).to eq ['iso639-2b']
              expect(smods_rec.record_info.recordContentSource.text).to eq 'CSt'
              expect(smods_rec.record_info.recordContentSource.authority).to eq ['marcorg']
              expect(smods_rec.record_info.recordOrigin.text).to start_with "Transformed from record for #{seed_uri}"
              expect(smods_rec.record_info.recordOrigin.text).to end_with "part of the collection (record ID #{collection_id})."
            end
          end
        end
      end
      it 'descMetadata output file created' do
        druid_id = 'druid:aa111aa2222'
        metadata_generator_service = Dor::WASSeed::DescMetadataGenerator.new("#{@fixtures}workspace", druid_id)
        metadata_generator_service.generate_metadata_output
        actual_output_file = "#{@fixtures}workspace/aa/111/aa/2222/aa111aa2222/metadata/descMetadata.xml"
        expect(File.exist?(actual_output_file)).to be true

        smods_rec = Stanford::Mods::Record.new
        smods_rec.from_file(actual_output_file)
        expect(smods_rec._location.url.text).to match %r{^https://swap.stanford.edu/*/}
        expect(smods_rec._location.url.text).to end_with 'http://www.epa.gov/'
      end
    end
  end
end
