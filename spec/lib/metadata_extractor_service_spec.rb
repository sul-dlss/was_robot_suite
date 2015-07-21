require 'spec_helper'
require 'metadata_extractor_service'

describe Dor::WASCrawl::MetadataExtractor do

  before(:all) do
    @staging_path = Pathname(File.dirname(__FILE__)).join("../fixtures/workspace")
    @collection_id = "test_collection"
    @crawl_id = "test_crawl"
  end
  
  
  
  context Dor::WASCrawl::MetadataExtractor,".call_java_library with druid that has one warc file" do
  
    it 'should create a valid output file' do
      druid_id = 'druid:ab123ab1234'
      metadata_extractor_service = Dor::WASCrawl::MetadataExtractor.new(@collection_id, @crawl_id, @staging_path.to_s, druid_id)
       
      metadata_extractor_service.run_metadata_extractor_jar
      
      output_file = "tmp/"+druid_id+".xml"
      expect(File.exist?(output_file)).to be_truthy 
      
      actual_output = File.read("tmp/"+druid_id+".xml")
      expected_output = <<-EOF 
<crawlObject>
<crawlId>test_crawl</crawlId>
<collectionId>test_collection</collectionId>
<files>
<file>
<name>WARC-Test.warc.gz</name>
<type>WARC</type>
<size>6608320</size>
<recordCount>4027</recordCount>
<mimeType>application/octet-stream</mimeType>
<checksumMD5>c7edbde066e4697b3f2d823ac42c3692</checksumMD5>
<checksumSHA1>3a9f2ffac1497c70291d93a8bc86c1469547d8f8</checksumSHA1>
<isPatchCrawl>false</isPatchCrawl>
<software> Heritrix/3.2.0-SNAPSHOT-20140108-2049 http://crawler.archive.org</software>
<organizationName>"Stanford University</organizationName>
<ip> 207.241.226.90</ip>
<accountType>SUBSCRIBER</accountType>
<creationDate>2014-01-19T22:37:40Z</creationDate>
<seedCount>68</seedCount>
<robotsPolicy> obey</robotsPolicy>
<recurrence>QUARTERLY</recurrence>
<isTestCrawl>false</isTestCrawl>
<accountId>159</accountId>
<hostname> wbgrp-crawl051.us.archive.org</hostname>
<datatype> WARC File Format 1.0</datatype>
<id>ARCHIVEIT-924-QUARTERLY-31501-20140119223740943-00015-wbgrp-crawl051.us.archive.org-6441.warc.gz</id>
<collectionId>924</collectionId>
<maxDuration>604800</maxDuration>
<user-agent> Mozilla/5.0 (compatible; archive.org_bot; Archive-It; +http://archive-it.org/files/site-owners.html)</user-agent>
</file>
</files>
</crawlObject>
EOF

#expect(Nokogiri::XML(expected_output).root).to be_equivalent_to(Nokogiri::XML(actual_output).root)
expect(Nokogiri::XML(expected_output).root.to_xml).to eq(Nokogiri::XML(actual_output).root.to_xml)
      
    end
    
    after(:all) do
     # File.delete("tmp/"+druid_id+".xml")
    end
    
  end
  
  
  context Dor::WASCrawl::MetadataExtractor,".prepare_parameters" do

    it 'should run successfully with existent druid' do
      druid_id = 'druid:ab123ab1234'
      metadata_extractor_service = Dor::WASCrawl::MetadataExtractor.new(@collection_id, @crawl_id, @staging_path.to_s, druid_id)
      metadata_extractor_service.prepare_parameters
      expect(metadata_extractor_service.instance_variable_get(:@input_directory)).to eq @staging_path.to_s+"/ab/123/ab/1234/ab123ab1234/content"
      expect(metadata_extractor_service.instance_variable_get(:@xml_output_location)).to eq  "tmp/druid:ab123ab1234.xml"

    end
    
    it 'should raise an error wrong druid' do
      druid_id = 'druid:xx999xxx9999'
      metadata_extractor_service = Dor::WASCrawl::MetadataExtractor.new(@collection_id, @crawl_id, @staging_path.to_s, druid_id)
      expect { metadata_extractor_service.prepare_parameters }.to raise_error      
    end
 
    it 'should raise an error with nil druid' do
      druid_id = nil
      metadata_extractor_service = Dor::WASCrawl::MetadataExtractor.new(@collection_id, @crawl_id, @staging_path.to_s, druid_id)
      expect { metadata_extractor_service.prepare_parameters }.to raise_error      
    end
    
    it 'should raise an error with existent druid tree without content folder' do
      druid_id = 'druid:ef123ef1234'
      metadata_extractor_service = Dor::WASCrawl::MetadataExtractor.new(@collection_id, @crawl_id,@staging_path.to_s, druid_id)
      expect { metadata_extractor_service.prepare_parameters }.to raise_error      
    end
  end
   
  context Dor::WASCrawl::MetadataExtractor,".build_cmd_string" do
    
    it 'should build the command string as expected' do
      druid_id = 'druid:ab123ab1234'
      expected_cmd_string = "java -Xmx1582m -jar jar_path -f XML -d input_directory -o tmp/druid:ab123ab1234.xml -c config/extractor.yml --collectionId test_collection --crawlId test_crawl 2>> log_file" 
        
      metadata_extractor_service = Dor::WASCrawl::MetadataExtractor.new(@collection_id, @crawl_id,@staging_path.to_s, druid_id)
      metadata_extractor_service.instance_variable_set(:@jar_path,"jar_path")
      metadata_extractor_service.instance_variable_set(:@input_directory , "input_directory")
      metadata_extractor_service.instance_variable_set(:@java_log_file , "log_file")
      metadata_extractor_service.instance_variable_set(:@xml_output_location , "tmp/druid:ab123ab1234.xml")

      actual_cmd_string = metadata_extractor_service.build_cmd_string
      expect(actual_cmd_string).to eq expected_cmd_string
    end
  end
  
end
