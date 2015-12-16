# Make sure specs run with the definitions from test.rb
ENV['ROBOT_ENVIRONMENT'] = 'test'

require 'coveralls'
Coveralls.wear!

bootfile = File.expand_path(File.dirname(__FILE__) + '/../config/boot')
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require bootfile

require 'pry'
require 'rspec'
require 'awesome_print'
require 'utilities'

require 'cdx_merge_sort_publish_service'
require 'path_indexer_service'
require 'cdx_generator_service'
