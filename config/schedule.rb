# frozen_string_literal: true

require_relative 'boot'

set :output, 'log/cdx_index_rollup.log'
set :environment_variable, 'ROBOT_ENVIRONMENT'

# These define jobs that checkin with Honeybadger.
# If changing the schedule of one of these jobs, also update at https://app.honeybadger.io/projects/51141/check_ins
job_type :rake_hb,
         'cd :path && :environment_variable=:environment bundle exec rake --silent ":task" :output && curl --silent https://api.honeybadger.io/v1/check_in/:check_in'

every 1.day, roles: [:rollup] do
  set :check_in, Settings.honeybadger_checkins.rollup_level1
  rake_hb 'cdxj:index:rollup:level1'
end

every 1.week, roles: [:rollup] do
  set :check_in, Settings.honeybadger_checkins.cleanup_indexes
  rake_hb 'cdxj:index:cleanup:indexes'
end

every 1.week, roles: [:rollup] do
  set :check_in, Settings.honeybadger_checkins.cleanup_empty_directories
  rake_hb 'cdxj:index:cleanup:empty_directories'
end

every 1.month, roles: [:rollup] do
  set :check_in, Settings.honeybadger_checkins.rollup_level2
  rake_hb 'cdxj:index:rollup:level2'
end

every 12.months, roles: [:rollup] do
  set :check_in, Settings.honeybadger_checkins.rollup_level3
  rake_hb 'cdxj:index:rollup:level3'
end
