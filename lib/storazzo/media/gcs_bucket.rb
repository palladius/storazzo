module Storazzo::Media

    class Storazzo::RicDisk::GcsBucket

    
        def self.list_all(config=nil)
            # get lisrts from Config singletone
            #puts " self.list_all: loading config "
            config ||= Storazzo::RicDiskConfig.instance # # ).get_config
            
            config.load # in case I need to load it for the first time
            #puts config['Config']['AdditionalMountDirs']
            #puts "TODO see config: #{config}"
            #[42, 43]
            #deb config.get_local_folders
            config.get_bucket_paths
        end


    end

end