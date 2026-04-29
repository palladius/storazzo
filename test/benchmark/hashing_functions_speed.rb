#!/usr/bin/env ruby

# thanks https://gist.github.com/morimori/1330095 !!

require 'digest/sha1'
require 'digest/sha2'
require 'benchmark'

SRC = File.read '/dev/urandom', 1024 * 1024

puts "SRC size: #{SRC.size}B"
Benchmark.bmbm do |bm|
  bm.report('MD5')    { 100_000.times { Digest::MD5.hexdigest    SRC } }
  bm.report('SHA1')   { 100_000.times { Digest::SHA1.hexdigest   SRC } }
  bm.report('SHA2')   { 100_000.times { Digest::SHA2.hexdigest   SRC } }
  # bm.report('SHA256') { 100000.times{ Digest::SHA256.hexdigest SRC } }
end
