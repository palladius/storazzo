#require 'rake'

# from hola: https://guides.rubygems.org/make-your-own-gem/#adding-an-executable
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << "test/media"
  t.verbose = false
  t.warning = false 
  #puts "[RiccardoOnly]: t.pattern: #{t.pattern}" 
  t.pattern = 'test/**/test_*.rb'
end

desc "Run tests"
task default: :test

# Adding test/media directory to rake test.
namespace :verbose_test do
  desc "Test tests/media/* code"
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.libs << "test/media"
    t.verbose = true
    t.warning = true 
    t.pattern = 'test/**/test_*.rb'
    #$DEBUG = true
  end
end
# namespace :verbose_test do
#   desc "Test tests/media/* code"
#   Rake::TestTask.new do |t|
#     t.libs << "test/media"
#     # Rails::TestTask.new(media: 'test:prepare') do |t|
#     t.pattern = 'test/**/test_*.rb'
#   end
# end
#Rake::Task['test:run'].enhance ["test:media"]

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



