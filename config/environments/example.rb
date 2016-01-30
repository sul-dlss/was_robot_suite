cert_dir = File.join(File.dirname(__FILE__), '..', 'certs')

Dor::Config.configure do
  workflow.url ''
  workflow.logfile 'log/workflow_service.log'
  workflow.shift_age 'weekly'
  solrizer.url ''

  robots do
    workspace '/tmp'
  end

  ssl do
    cert_file File.join(cert_dir, '.crt')
    key_file File.join(cert_dir, '.key')
    key_pass ''
  end

  was_crawl do
    source_path   '/web-archiving-stage/jobs/' # the root for the storage for the input directory
    staging_path  '/dor/workspace/'  # the root for the storage for DRUID tree that will be the input to AssemblyWF
    extracted_metadata_xml_location   'tmp'
    metadata_extractor_jar  'jar/WASMetadataExtractor.jar'
    java_heap_size  '-Xmx6144m'
    dedicated_lane  'W'
  end

  suri do
    mint_ids true
    id_namespace 'druid'
    url ''
    user ''
    pass ''
  end

  dor do
    service_root ''
  end

  fedora do
    url ''
  end
end
REDIS_URL = ''
WORKFLOW_URI = ''
