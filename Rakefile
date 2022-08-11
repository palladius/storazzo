# frozen_string_literal: true

# require 'rake'

# from hola: https://guides.rubygems.org/make-your-own-gem/#adding-an-executable
require 'rake/testtask'

desc 'Run Unit tests'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'test/media'
  # NOTE: this is only useful for this: https://chriskottom.com/articles/command-line-flags-for-minitest-in-the-raw/
  t.verbose = false
  t.warning = false
  # puts "[RiccardoOnly]: t.pattern: #{t.pattern}"
  t.pattern = 'test/**/test_*.rb'
end

desc 'By default, Run Unit tests'
task default: :test

# Adding test/media directory to rake test.
desc 'Test tests/media/* code sobenem'
namespace :test do
  desc "Test Verbosely by default since I'm too stupid to toggle via ENV var dammit"
  Rake::TestTask.new(:verbose) do |t|
    t.libs << 'test'
    t.libs << 'test/media'
    t.verbose = true
    t.warning = true
    t.pattern = 'test/**/test_*.rb'
    $DEBUG = true
  end

  desc 'Test Silently and removes VERBOSITY'
  Rake::TestTask.new(:silent) do |t|
    t.libs << 'test'
    t.libs << 'test/media'
    t.verbose = false
    t.warning = false
    t.pattern = 'test/**/test_*.rb'
    puts "Note: Best to call me with RUBYOPT='-W0'. Now RUBYOPT=#{ENV['RUBYOPT']}" if ENV['RUBYOPT'].nil?
    $DEBUG = false
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
# Rake::Task['test:run'].enhance ["test:media"]

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
