#require 'rake'

# from hola: https://guides.rubygems.org/make-your-own-gem/#adding-an-executable
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.verbose = false
  t.warning = false 
end

desc "Run tests"
task default: :test


# begin
#     require 'bundler/setup'
#     Bundler::GemHelper.install_tasks
#   rescue LoadError
#     puts 'although not required, bundler is recommended for running the tests'
#   end
  
#   task default: :spec
  
#   require 'rspec/core/rake_task'
#   RSpec::Core::RakeTask.new(:spec)
  
#   require 'rubocop/rake_task'
#   RuboCop::RakeTask.new do |task|
#     task.requires << 'rubocop-performance'
#     task.requires << 'rubocop-rspec'
#   end