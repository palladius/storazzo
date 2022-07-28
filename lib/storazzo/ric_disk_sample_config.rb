require 'singleton'
require 'yaml'
#require "ric_disk_config"

=begin
    This is a singleton class. You call me this way..
    You call me with:

    Storazzo::RicDiskSampleConfig.instance()

=end

module Storazzo
    
    # ric_disk_sample_config
    class Storazzo::RicDiskSampleConfig < Storazzo::RicDiskConfig
        include Singleton

    public
        def load # _sample_version
            puts white("Wheew! We're NOT destroying the world here. We're actually instancing a second Singleton which is a child of the mother, and this time doing things nicely and Rubily.")
            super.load(DefaultGemLocationForTests, :verbose => true )
        end

    end

end # module Storazzo

