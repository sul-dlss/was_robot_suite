server 'was-robots1-stage.stanford.edu', user: 'was', roles: %w{web app db rollup}

Capistrano::OneTimeKey.generate_one_time_key!

set :deploy_environment, 'test'
set :whenever_environment, fetch(:deploy_environment)
set :honeybadger_env, fetch(:deploy_environment)
set :default_env, { robot_environment: fetch(:deploy_environment) }
set :bundle_without, %w{deployment test}.join(' ')
