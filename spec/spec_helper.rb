
require 'simplecov'
SimpleCov.start do # 'rails'
  add_filter '/spec/'
  add_filter '/vendor/'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'awesome_print'
require 'pry'

require 'wisper_subscription'
