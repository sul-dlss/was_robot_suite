# Make sure specs run with the definitions from test.rb
ENV['ROBOT_ENVIRONMENT'] = 'test'

require 'coveralls'
Coveralls.wear!

bootfile = File.expand_path(File.dirname(__FILE__) + '/../config/boot')
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require bootfile

require 'was_crawl_preassembly/utilities'

# for wasCrawlDissemination specs
require 'was_crawl_dissemination/cdx_merge_sort_publish_service'
require 'was_crawl_dissemination/path_indexer_service'
require 'was_crawl_dissemination/cdx_generator_service'
require 'was_crawl_dissemination/utilities'

# for wasSeedDissemination
require 'wasSeedDissemination/update_thumbnail_generator'

#require 'pry'
require 'rspec'
require 'awesome_print'
require 'nokogiri'
require 'equivalent-xml'
require 'equivalent-xml/rspec_matchers'
