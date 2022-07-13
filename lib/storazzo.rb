# Inspired from https://guides.rubygems.org/make-your-own-gem/#introduction


module Storazzo
    #VERSION = File.read('./VERSION').chomp # "10.0.0"
    #require 'storazzo/translator'

    def latest_parser_version 
        "1.2"
    end 

    # Finds RAILS_ROOT for Storazzo Gem. Copied from:
    # https://stackoverflow.com/questions/10132949/finding-the-gem-root
    def self.root 
        File.expand_path '../..', __FILE__
    end

    def self.version 
        File.read('./VERSION').chomp # "10.0.0"
    end
end 

require 'storazzo/colors'
require 'storazzo/hashify'
require 'storazzo/ric_disk'
require 'storazzo/main'
require 'storazzo/translator'

puts Storazzo::Main.hi 

