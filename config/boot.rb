# Ensure subsequent requires search the correct local paths
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'robots'))

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'logger'
require 'workflow_client_factory'

# Load the environment file based on Environment.  Default to development
environment = ENV['ROBOT_ENVIRONMENT'] ||= 'development'
ROBOT_ROOT = File.expand_path("#{File.dirname(__FILE__)}/..")
ROBOT_LOG = Logger.new(File.join(ROBOT_ROOT, "log/#{environment}.log"))
ROBOT_LOG.level = Logger::SEV_LABEL.index(ENV['ROBOT_LOG_LEVEL']) || Logger::INFO

require 'config'
Config.setup do |config|
  # Name of the constant exposing loaded settings
  config.const_name = 'Settings'
  # Load environment variables from the `ENV` object and override any settings defined in files.
  #
  config.use_env = true

  # Define ENV variable prefix deciding which variables to load into config.
  #
  config.env_prefix = 'SETTINGS'

  # What string to use as level separator for settings loaded from ENV variables. Default value of '.' works well
  # with Heroku, but you might want to change it for example for '__' to easy override settings from command line, where
  # using dots in variable names might not be allowed (eg. Bash).
  #
  config.env_separator = '__'
end

Config.load_and_set_settings(
  Config.setting_files(File.expand_path(__dir__), environment)
)

# Override Solrizer's logger before it gets a chance to load and pollute STDERR.
begin
  require 'solrizer'
  Solrizer.logger = ROBOT_LOG
rescue LoadError, NameError, NoMethodError
end

# Load core robot services
require 'lyber_core'

# Load any library files and all the robots
# TODO: Maybe move auto-require to just run_robot and spec_helper?
Dir["#{ROBOT_ROOT}/lib/*/*.rb"].sort.each { |f| require f }
require 'robots'

REDIS_URL ||= Settings.redis.url # rubocop:disable Lint/OrAssignmentToConstant

module Was
  def self.connect_dor_services_app
    Dor::Services::Client.configure(url: Settings.dor_services.url,
                                    token: Settings.dor_services.token)
  end
end

Was.connect_dor_services_app

# Load Resque configuration and controller
require 'resque'
Resque.redis = (defined? REDIS_URL) ? REDIS_URL : "localhost:6379/resque:#{ENV['ROBOT_ENVIRONMENT']}"
