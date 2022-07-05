# frozen_string_literal: true

set :output, 'log/cdx_index_rollup.log'
set :environment_variable, 'ROBOT_ENVIRONMENT'

every 1.day, roles: [:rollup] do
  rake 'cdx:index:rollup:level1'
  rake 'cdxj:index:rollup:level1'
end

every 1.month, roles: [:rollup] do
  rake 'cdx:index:rollup:level2'
  rake 'cdxj:index:rollup:level2'
end

every 12.months, roles: [:rollup] do
  rake 'cdx:index:rollup:level3'
  rake 'cdxj:index:rollup:level3'
end
