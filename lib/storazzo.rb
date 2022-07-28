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
        File.read(self.root + '/VERSION').chomp # "10.0.0"
    end

#    alias_method :VERSION, :version 
    def self.VERSION 
        version
    end

    def self.storazzo_classes
        [42, 43]
    end
end 

# nice to paste nice output
require 'pp'

require 'storazzo/ric_disk_sample_config'  # => NOTHING!!

require 'storazzo/common'
require 'storazzo/colors'
require 'storazzo/hashify'
require 'storazzo/ric_disk'          # NEW and will build from ground up using multiple files..
#require 'storazzo/ric_disk/asbtract_ric_disk'
require 'storazzo/media/abstract_ric_disk'
require 'storazzo/media/gcs_bucket' 
require 'storazzo/media/local_folder' 
require 'storazzo/ric_disk_ugly'     # OLD and 90% working
require 'storazzo/ric_disk_config'         # => RicDiskConfif
require 'storazzo/ric_disk_statsfile'
require 'storazzo/main'
require 'storazzo/translator'

#puts Storazzo::Main.say_hi 
