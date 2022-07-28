require 'singleton'
require 'yaml'

require_relative "./common"
require_relative "./ric_disk_config"

=begin
    This is a singleton class. You call me this way..
    You call me with:

    Storazzo::RicDiskSampleConfig.instance()

=end

module Storazzo

    class Storazzo::RicDiskSampleConfig < Storazzo::RicDiskConfig
        #include Storazzo::Common

        include Singleton
        public
            def load # _sample_version
                puts white("Wheew! We're NOT destroying the world here. We're actually instancing a second Singleton which is a child of the mother, and this time doing things nicely and Rubily.")
                super.load(DefaultGemLocationForTests, :verbose => true )
            end
     end

    #puts "[REMOVEME]1 Storazzo::RicDiskSampleConfig was read"
end # module Storazzo

#puts "[REMOVEME]2 Storazzo::RicDiskSampleConfig was read"
