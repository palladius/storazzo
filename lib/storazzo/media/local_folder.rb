#require "storazzo/ric_disk/abstract_ric_disk"
#require "abstract_ric_disk"

module Storazzo::Media
    class Storazzo::Media::LocalFolder < Storazzo::Media::AbstractRicDisk

        attr_accessor :local_mountpoint

        def initialize(local_mount)
            puts "[Storazzo::Media::LocalFolder] initialize"
            super.initialize
            @local_mountpoint = local_mount
        end
        
        def self.list_all
            # get lisrts from Config singletone
            puts " self.list_all: loading config "
            config = Storazzo::RicDiskConfig.instance# # ).get_config
            #puts config['Config']['AdditionalMountDirs']
            #puts "TODO see config: #{config}"
            #[42, 43]
            #deb config.get_local_folders
            config.get_local_folders
        end

    end

end