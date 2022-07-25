#require "storazzo/ric_disk/abstract_ric_disk"
#require "abstract_ric_disk"

module Storazzo::Media
    class Storazzo::Media::LocalFolder < Storazzo::Media::AbstractRicDisk

        attr_accessor :local_mountpoint, :wr

        def initialize(local_mount)
            puts "[Storazzo::Media::LocalFolder] initialize"
            
            @local_mountpoint = File.expand_path(local_mount)
            raise "Sorry local mount doesnt exist!" unless File.exist?(@local_mountpoint)
            @wr = File.writable?("#{path}/#{stats_filename}" ) # .writeable?

            super.initialize(local_mount) rescue "SUPER_ERROR: #{$!}"
        end
        
        def self.list_all
            # get lisrts from Config singletone
            #puts " self.list_all: loading config "
            config = Storazzo::RicDiskConfig.instance # # ).get_config
            #puts config['Config']['AdditionalMountDirs']
            #puts "TODO see config: #{config}"
            #[42, 43]
            #deb config.get_local_folders
            config.get_local_folders
        end

        def parse(opts={})
            puts "LF.parse(#{opts}): TODO Sbrodola inside the dir: #{local_mountpoint}"
            parse_block_storage_folder()
        end

        def path
            @local_mountpoint
        end

        def self.default_stats_filename 
            super
        end
        # def stats_filename 
        #     #'42'
        #     self.default_stats_filename 
        # end

    end

end