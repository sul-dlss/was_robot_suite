# Make sure specs run with the definitions from test.rb
ENV['ROBOT_ENVIRONMENT'] = 'test'

require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require File.expand_path("#{File.dirname(__FILE__)}/../config/boot")

require 'rspec'
require 'awesome_print'
require 'nokogiri'
require 'equivalent-xml'
require 'equivalent-xml/rspec_matchers'
