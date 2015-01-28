
require 'simplecov'
SimpleCov.start do # 'rails'
  add_filter '/spec/'
  add_filter '/vendor/'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'wisper_subscription'
