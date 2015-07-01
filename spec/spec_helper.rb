# Make sure specs run with the definitions from test.rb
environment = ENV['ROBOT_ENVIRONMENT'] = 'test'

bootfile = File.expand_path(File.dirname(__FILE__) + '/../config/boot')
require bootfile

require 'pry'
require 'rspec'
require 'nokogiri'

require_relative '../robots/update_thumbnail_generator'
