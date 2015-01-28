
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = [
    'lib/**/*.rb',
    'spec/spec_helper.rb',
    'spec/**/*_spec.rb'
  ]
  task.formatters = ['simple', 'd']
  task.fail_on_error = true
  # task.options << '--rails'
end

RSpec::Core::RakeTask.new :spec

task(:default).clear
task default: [:spec, :rubocop]
