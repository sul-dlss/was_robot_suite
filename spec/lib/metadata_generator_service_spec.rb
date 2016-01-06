require 'spec_helper'
require 'metadata_generator_service'
require 'fileutils'
describe Dor::WASCrawl::MetadataGenerator do

  before(:all) do
    @staging_path = Pathname(File.dirname(__FILE__)).join('../fixtures/workspace')
    @extracted_metadata_xml_location = Pathname(File.dirname(__FILE__)).join('../fixtures/xml_extracted_metadata')
    @collection_id = 'test_collection'
    generate_data_items
  end

  context Dor::WASCrawl::MetadataGenerator, 'read_metadata_xml_input_file' do

    it 'should read the file successfully if druid id is passed' do
      druid_id = 'druid:gh123gh1234'
      metadata_generator_service = generate_object(druid_id)
      metadata_generator_service.instance_variable_set(:@extracted_metadata_xml_location, @extracted_metadata_xml_location)

      actual_xml = metadata_generator_service.read_metadata_xml_input_file
      expect(actual_xml.to_s).to eq @druid_gh123gh1234_expected_xml
    end

    it "should raise an error if the file doesn't exists" do
      druid_id = 'druid:xx'
      metadata_generator_service = generate_object(druid_id)
      metadata_generator_service.instance_variable_set(:@extracted_metadata_xml_location, @extracted_metadata_xml_location)

      expect{ metadata_generator_service.read_metadata_xml_input_file }.to raise_error
    end

    it 'should raise an error if the file is not a valid xml' do
      # Here, we focus on a valid xml, there is no schema validation
      druid_id = 'druid:xx_invalid'
      metadata_generator_service = generate_object(druid_id)
      metadata_generator_service.instance_variable_set(:@extracted_metadata_xml_location, @extracted_metadata_xml_location)

      expect{ metadata_generator_service.read_metadata_xml_input_file }.to raise_error
    end

  end

  context Dor::WASCrawl::MetadataGenerator, 'write_file_to_druid_metadata_folder' do
    it "should raise an error if the druid directory tree doesn't exist in the workspace" do
      druid_id = 'druid:xx111xx1111'
      metadata_generator_service = generate_object(druid_id)

      metadata_file_name = 'test_name'
      metadata_content = 'test_content'
      expect{ metadata_generator_service.write_file_to_druid_metadata_folder(metadata_file_name, metadata_content)}.to raise_error
    end

    it 'should create the metadata directory in the druid tree and create the metadata file in it' do
      druid_id = 'druid:ij123ij1234'
      metadata_generator_service = generate_object(druid_id)

      metadata_file_name = 'test_name'
      metadata_content = 'test_content'
      expected_metadata_directory = "#{@staging_path}/ij/123/ij/1234/ij123ij1234/metadata/"
      expected_output_file = "#{@staging_path}/ij/123/ij/1234/ij123ij1234/metadata/test_name.xml"

      metadata_generator_service.write_file_to_druid_metadata_folder(metadata_file_name, metadata_content)

      expect(File.exist?(expected_metadata_directory)).to be_truthy
      expect(File.exist?(expected_output_file)).to be_truthy

      expect(File.read(expected_output_file)).to eq metadata_content
      File.delete(expected_output_file)
      Dir.delete(expected_metadata_directory)
    end

    it 'should write the file in the druid metadata folder' do
      druid_id = 'druid:gh123gh1234'
      metadata_generator_service = generate_object(druid_id)

      metadata_file_name = 'test_name'
      metadata_content = 'test_content'
      expected_output_file = "#{@staging_path}/gh/123/gh/1234/gh123gh1234/metadata/test_name.xml"

      metadata_generator_service.write_file_to_druid_metadata_folder(metadata_file_name, metadata_content)

      expect(File.exist?(expected_output_file)).to  be_truthy
     expect( File.read(expected_output_file)).to eq metadata_content
      File.delete(expected_output_file)
    end
  end

  context Dor::WASCrawl::MetadataGenerator, 'read_template' do

    it 'should read the contentMetadata template successfully' do
      druid_id = 'druid:gh123gh1234'
      metadata_generator_service = generate_object(druid_id)

      actual_xsl = metadata_generator_service.read_template('contentMetadata_public')
      expect(actual_xsl.to_s.length).to be > 1
    end

    it 'should read the technicalMetadata template successfully' do
      druid_id = 'druid:gh123gh1234'
      metadata_generator_service = generate_object(druid_id)

      actual_xsl = metadata_generator_service.read_template('technicalMetadata')
       expect(actual_xsl.to_s.length).to be > 1
    end

    it 'should read the descMetadata template successfully' do
      druid_id = 'druid:gh123gh1234'
      metadata_generator_service = generate_object(druid_id)

      actual_xsl = metadata_generator_service.read_template('descMetadata')
      expect(actual_xsl.to_s.length).to be > 1
    end

    it "should raise an error if the file doesn't exists" do
      druid_id = 'druid:xx'
      metadata_generator_service = generate_object(druid_id)
      metadata_generator_service.instance_variable_set(:@extracted_metadata_xml_location, @extracted_metadata_xml_location)

     expect{ actual_xsl = metadata_generator_service.read_template('nothginMetadata') }.to raise_error
    end

  end

  context Dor::WASCrawl::MetadataGenerator, 'transform_xml_using_xslt' do
    it 'should transform the xml using xslt with valid inputs' do
      druid_id = 'druid:xx'
      metadata_generator_service = generate_object(druid_id)
      xml_doc = <<-EOF
      <?xml version="1.0" ?>
       <UserList><User>
        <Name>John Smith</Name>
        <Account>John</Account>
      </User></UserList>
      EOF

      xslt_doc = <<-EOF
      <?xml version="1.0" ?>
      <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
         <xsl:template match="/">
           <newuserlist> <newuser>
            <xsl:value-of select="UserList/User/Name" />
           </newuser> </newuserlist>
         </xsl:template>
      </xsl:stylesheet>
      EOF
      expected_transformed = <<-EOF
<?xml version="1.0"?>
<newuserlist>
  <newuser>John Smith</newuser>
</newuserlist>
EOF
      actual_transformed =   metadata_generator_service.transform_xml_using_xslt(xml_doc, xslt_doc)
      expect(actual_transformed.to_s).to eq expected_transformed
    end
  end

  context Dor::WASCrawl::MetadataGenerator, 'do_post_transform' do
    it 'should return the string with no modification' do
      druid_id = 'druid:gh123gh1234'
      metadata_generator_service = generate_object(druid_id)

      test_string = 'test_string'
      actual_string = metadata_generator_service.do_post_transform(test_string)

      expect(actual_string).to eq test_string
    end
  end

  def generate_object(druid_id)
     metadata_generator_service = Dor::WASCrawl::MetadataGenerator.new(@collection_id,
      @staging_path.to_s, druid_id)
     metadata_generator_service
  end

  def generate_data_items()
    @druid_gh123gh1234_expected_xml=<<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<crawlObject>
   <crawlId/>
   <collectionId/>
   <files>
      <file>
         <name>ARC-Test.arc.gz</name>
         <type>ARC</type>
         <size>87846905</size>
         <recordCount>27089</recordCount>
         <mimeType>application/octet-stream</mimeType>
         <checksumMD5>f05e6759eeebbed5e17266809872c9f3</checksumMD5>
         <checksumSHA1>e4fd69c988b5abb5d082e4ec897a582d74dc2bbf</checksumSHA1>
         <id>ARCHIVEIT-1078-STANFORD-CRS-20090212171334-00078-crawling015.us.archive.org.arc</id>
         <creationDate>20090212171334</creationDate>
         <software>Heritrix 1.14.2 http://crawler.archive.org</software>
         <description>Congressional Research Service (CRS) is a "think tank" that provides research reports to members of Congress on a variety of topics relevant to current political events. However, the Congressional Research Service (CRS) does not provide direct public access to its reports, nor are they released to the public via the Federal Library Depository Program (FDLP). There are several organizations that collect and give access to subsets of published CRS Reports. This collection attempts to bring all CRS Reports together in one place.</description>
         <robotsPolicy>classic</robotsPolicy>
         <hostname>crawling015.us.archive.org</hostname>
         <user-agent>Mozilla/5.0 (compatible;archive.org_bot/1.13.1; collectionId=1078; Archive-It; +http://www.archive-it.org)</user-agent>
         <isPartOf>1078</isPartOf>
         <datatype>ARC file version 1.1</datatype>
         <operator/>
         <ip>207.241.235.73</ip>
      </file>
      <file>
         <name>test.txt</name>
         <type>GENERAL</type>
         <size>4</size>
         <recordCount>0</recordCount>
         <mimeType>text/plain</mimeType>
         <checksumMD5>e2fc714c4727ee9395f324cd2e7f331f</checksumMD5>
         <checksumSHA1>81fe8bfe87576c3ecb22426f8e57847382917acf</checksumSHA1>
      </file>
      <file>
         <name>WARC-Test.warc.gz</name>
         <type>WARC</type>
         <size>6608320</size>
         <recordCount>4027</recordCount>
         <mimeType>application/octet-stream</mimeType>
         <checksumMD5>c7edbde066e4697b3f2d823ac42c3692</checksumMD5>
         <checksumSHA1>3a9f2ffac1497c70291d93a8bc86c1469547d8f8</checksumSHA1>
         <isPatchCrawl>false</isPatchCrawl>
         <accountId>159</accountId>
         <collectionId>924</collectionId>
         <organizationName>"Stanford University</organizationName>
         <robotsPolicy>obey</robotsPolicy>
         <hostname>wbgrp-crawl051.us.archive.org</hostname>
         <user-agent>Mozilla/5.0 (compatible; archive.org_bot; Archive-It; +http://archive-it.org/files/site-owners.html)</user-agent>
         <maxDuration>604800</maxDuration>
         <isTestCrawl>false</isTestCrawl>
         <ip>207.241.226.90</ip>
         <id>ARCHIVEIT-924-QUARTERLY-31501-20140119223740943-00015-wbgrp-crawl051.us.archive.org-6441.warc.gz</id>
         <creationDate>2014-01-19T22:37:40Z</creationDate>
         <software>Heritrix/3.2.0-SNAPSHOT-20140108-2049 http://crawler.archive.org</software>
         <recurrence>QUARTERLY</recurrence>
         <seedCount>68</seedCount>
         <accountType>SUBSCRIBER</accountType>
         <datatype>WARC File Format 1.0</datatype>
      </file>
   </files>
</crawlObject>
EOF
  end

end
