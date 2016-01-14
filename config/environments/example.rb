Dor::Config.configure do
  workflow.url ''

  was_seed do
    workspace_path  '/dor/workspace/'  #the root for the storage for DRUID tree that will be the input to AssemblyWF
    staging_path  '/web-archiving-stage/seed/'
    wayback_uri 'https://swap.stanford.edu'
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
end

REDIS_URL = 'localhost:6379/resque:example' # hostname:port[:db][/namespace]
