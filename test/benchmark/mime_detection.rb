# frozen_string_literal: true

require 'benchmark'
require 'mime/types'
require 'marcel'
require 'fileutils'

# A benchmarking script to compare different MIME-type detection methods.
# 1. System 'file' command
# 2. mime-types gem
# 3. marcel gem

# Gathering some files for benchmarking
files = Dir.glob("{lib,assets,test,var/test/disks}/**/*").select { |f| File.file?(f) }.first(100)

if files.empty?
  puts "No files found for benchmarking. Creating some dummy files..."
  FileUtils.mkdir_p("tmp/benchmark_files")
  100.times do |i|
    f = "tmp/benchmark_files/file_#{i}.txt"
    File.write(f, "Dummy content #{i}")
    files << f
  end
end

puts "Benchmarking MIME-type detection for #{files.size} files..."

Benchmark.bm(20) do |x|
  x.report("system 'file':") do
    files.each do |f|
      `file --mime-type -b '#{f}' 2>/dev/null`.chomp
    end
  end

  x.report("mime-types gem:") do
    files.each do |f|
      MIME::Types.type_for(f).first&.content_type || 'application/octet-stream'
    end
  end

  x.report("marcel gem:") do
    files.each do |f|
      Marcel::MimeType.for(Pathname.new(f))
    end
  end
end

# Verify accuracy for a few known files
puts "\nAccuracy Check:"
known_files = Dir.glob("assets/*.png").first(2) + Dir.glob("lib/**/*.rb").first(2)
known_files.each do |f|
  sys = `file --mime-type -b '#{f}' 2>/dev/null`.chomp
  mt = MIME::Types.type_for(f).first&.content_type || 'unknown'
  ma = Marcel::MimeType.for(Pathname.new(f))
  puts "File: #{f}"
  puts "  System: #{sys}"
  puts "  MIME-T: #{mt}"
  puts "  Marcel: #{ma}"
end
