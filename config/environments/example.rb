Dor::Config.configure do

  workflow.url ''

  robots do 
    workspace '/tmp'
  end
  
  was_crawl_dissemination do
    
    java_heap_size  '-Xmx1024m'
    cdx_working_directory "./web-archiving-stacks/data/indecies/cdx_working/"
    cdx_backup_directory  "./web-archiving-stacks/data/indecies/cdx_backup/"
    main_cdx_file "./web-archiving-stacks/data/indecies/cdx/index.cdx"

    path_working_directory "./web-archiving-stacks/data/indecies/path_working/"
    main_path_index_file "./web-archiving-stacks/data/indecies/path/path-index.txt"

    cdx_indexer_script "jar/openwayback/bin/cdx-indexer"
    stacks_collections_path "./web-archiving-stacks/data/collections/"
  end

  dor do
    service_root ''
  end
end

REDIS_URL = "localhost:6379/resque:test"