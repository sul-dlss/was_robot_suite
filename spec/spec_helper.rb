# Make sure specs run with the definitions from test.rb
ENV['ROBOT_ENVIRONMENT'] = 'test'

require 'simplecov'
SimpleCov.start

require File.expand_path("#{__dir__}/../config/boot")
require 'rspec'
require 'awesome_print'
require 'nokogiri'
require 'equivalent-xml'
require 'equivalent-xml/rspec_matchers'
require 'cocina/rspec'
require 'pry-byebug'
