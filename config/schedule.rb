set :output, 'log/cdx_index_rollup.log'
every 1.day, roles: [:rollup] do
  rake 'cdx:index:rollup:level1'
end

every 1.month, roles: [:rollup] do
  rake 'cdx:index:rollup:level2'
end

every 12.months, roles: [:rollup] do
  rake 'cdx:index:rollup:level3'
end

every 5.minutes, roles: [:monitor] do
  # cannot use :output with Hash/String because we don't want append behavior
  set :output, proc { '> log/verify.log 2> log/cron.log' }
  set :environment_variable, 'ROBOT_ENVIRONMENT'
  rake 'robots:verify'
end
