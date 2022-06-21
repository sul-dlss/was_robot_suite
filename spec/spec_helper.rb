# Make sure specs run with the definitions from test.rb
ENV['ROBOT_ENVIRONMENT'] = 'test'

require 'simplecov'
SimpleCov.start :rails do
  add_filter '/bin/'
  add_filter '/config/'
  add_filter '/spec/'
  add_filter '/vendor/'
end

require File.expand_path("#{__dir__}/../config/boot")
require 'rspec'
require 'awesome_print'
require 'nokogiri'
require 'equivalent-xml'
require 'equivalent-xml/rspec_matchers'
require 'cocina/rspec'
require 'pry-byebug'
