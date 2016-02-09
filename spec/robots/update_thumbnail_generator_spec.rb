describe Robots::DorRepo::WasSeedDissemination::UpdateThumbnailGenerator do
  describe '.get_original_uri' do
    it 'returns the original uri from descriptive metadata note fields' do
      descMetadata = '<mods xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd"><typeOfResource>text</typeOfResource> <note>Archived by Stanford University, Social Sciences Resource Group.</note> <note displayLabel="Web archiving service">Archive-It</note>  <note type="system details" displayLabel="Original site">http://naca.central.cranfield.ac.uk/</note></mods>'
      update_thumbnail_generator = Robots::DorRepo::WasSeedDissemination::UpdateThumbnailGenerator.new
      expect(update_thumbnail_generator.get_original_uri Nokogiri::XML(descMetadata)).to eq('http://naca.central.cranfield.ac.uk/')
    end
    it 'returns the original uri from descriptive metadata note fields' do
      descMetadata = '<mods xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd"><typeOfResource>text</typeOfResource> <note>Archived by Stanford University, Social Sciences Resource Group.</note> <note displayLabel="Web archiving service">Archive-It</note> </mods>'
      update_thumbnail_generator = Robots::DorRepo::WasSeedDissemination::UpdateThumbnailGenerator.new
      expect(update_thumbnail_generator.get_original_uri Nokogiri::XML(descMetadata)).to eq('')
    end
  end
end
