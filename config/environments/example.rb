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
    url Settings.workflow.url
    logfile Settings.workflow.logfile
    shift_age Settings.workflow.shift_age
  end

  solr.url ''
end

REDIS_URL = 'localhost:6379/resque:test'
