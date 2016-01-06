require 'spec_helper'
require 'technical_metadata_generator_service'

describe Dor::WASCrawl::TechnicalMetadataGenerator do

  before(:all) do
    @staging_path = Pathname(File.dirname(__FILE__)).join('../fixtures/workspace')
    @extracted_metadata_xml_location = Pathname(File.dirname(__FILE__)).join('../fixtures/xml_extracted_metadata')
    @collection_id = 'test_collection'
    @crawl_id = 'test_crawl'
    generate_data_items
  end

  context Dor::WASCrawl::TechnicalMetadataGenerator, 'generate_metadata_output' do
    it 'should generate technicalMetadata with valid input' do
        druid_id = 'druid:gh123gh1234'
      metadata_generator_service = generate_object(druid_id)
      metadata_generator_service.instance_variable_set(:@extracted_metadata_xml_location, @extracted_metadata_xml_location)

      metadata_generator_service.generate_metadata_output
      @expected_technical_metadata

      expected_output_file = "#{@staging_path}/gh/123/gh/1234/gh123gh1234/metadata/technicalMetadata.xml"
      actual_technical_metadata = File.read(expected_output_file)
      expect(actual_technical_metadata).to eq @expected_technical_metadata
    end

    after(:each) do
      expected_output_file = "#{@staging_path}/gh/123/gh/1234/gh123gh1234/metadata/technicalMetadata.xml"
      File.delete(expected_output_file)
    end
  end

  def generate_object(druid_id)
     metadata_generator_service = Dor::WASCrawl::TechnicalMetadataGenerator.new(@collection_id,
      @staging_path.to_s, druid_id)
     metadata_generator_service
  end

  def generate_data_items()
    @expected_technical_metadata = <<-EOF
<?xml version="1.0"?>
<technicalMetadata>
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
</technicalMetadata>
EOF
  end


end
