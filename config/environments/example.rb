cert_dir = File.join(File.dirname(__FILE__), '..', 'certs')

Dor::Config.configure do
  fedora do
    url ''
  end

  ssl do
    cert_file File.join(cert_dir, '.crt')
    key_file File.join(cert_dir, '.key')
    key_pass ''
  end

  suri do
    mint_ids true
    id_namespace 'druid'
    url ''
    user ''
    pass ''
  end

  workflow do
    url 'http://example.com/'
    logfile 'log/wfs/workflow_service.log'
    shift_age 'weekly'
  end

  solr.url ''
  dor_services.url ''

  robots do
    workspace '/tmp'
  end

  was_crawl do
    source_path   '/was_unaccessioned_data/jobs/' # the root for the storage for the input directory
    staging_path  '/dor/workspace/'  # the root for the storage for DRUID tree that will be the input to AssemblyWF
    extracted_metadata_xml_location   'tmp'
    metadata_extractor_jar  'jar/WASMetadataExtractor.jar'
    java_heap_size  '-Xmx2048m'
    # dedicated_lane  'default'
  end

  was_crawl_dissemination do
    java_heap_size  '-Xmx1024m'
    cdx_working_directory "/web-archiving-stacks/data/indices/cdx_working/"
    cdx_backup_directory  "/web-archiving-stacks/data/indices/cdx_backup/"
    main_cdx_file "/web-archiving-stacks/data/indices/cdx/level0.cdx"

    path_working_directory "/web-archiving-stacks/data/indices/path_working/"
    main_path_index_file "/web-archiving-stacks/data/indices/path/path-index.txt"

    cdx_indexer_script "jar/openwayback/bin/cdx-indexer"
    stacks_collections_path "/web-archiving-stacks/data/collections/"
    sort_env_vars "TMPDIR=/web-archiving-stacks/data/tmp/ LC_ALL=C"
  end

  was_seed do
    workspace_path  '/dor/workspace/'  #the root for the storage for DRUID tree that will be the input to AssemblyWF
    staging_path  '/was_unaccessioned_data/seed/'
    wayback_uri 'https://swap.stanford.edu'
  end

  thumbnail_generator_service_uri ''  # for was-seed-dissemination

end
#REDIS_URL = ''
REDIS_URL = 'localhost:6379/resque:test'
