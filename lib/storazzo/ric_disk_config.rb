require 'singleton'
require 'yaml'

module Storazzo
    class Storazzo::RicDiskConfig 
        include Singleton
        include Storazzo::Common
        include Storazzo::Colors
        
        @@default_config_location = "~/.storazzo.yaml" 
        attr_accessor :config, :config_file

public
        def load(config_path=nil, opts={})
            verbose = opts.fetch :verbose, false

            puts "[VERBOSE] Storazzo::RicDiskConfig.load(): BEGIN " if verbose
            # trying default location
            possible_locations = [ @@default_config_location , "./.storazzo.yaml"]
            if config_path 
                possible_locations =possible_locations.append(config_path) 
            end
            puts "[VERBOSE] Searching these paths in order: #{possible_locations}" if verbose
            possible_locations.each do |possible_path|
                paz = File.expand_path(possible_path)
                #puts "DEB paz:#{paz}"
                if File.exists?(paz) 
                    @config_file = paz 
                    @config = YAML.load(File.read paz) # YAML.load(File.read("file_path"))
                    #pp @config if verbose
                    #config_ver = @config[:ConfigVersion]
                    #puts @config[:ConfigVersion]
                    puts "Storazzo::RicDiskConfig v#{config_ver} parsed correctly"
                    puts "RicDiskConfig.to_s: #{self}" if verbose
                    return self.config
                end
            end
            # only get here if nothing is found
            raise "No config found across these locations: #{possible_locations}. Consider copying and editing: #{RicDiskConfig.gem_default_config_path}"
#            @config = 42
#            puts "[VERBOSE] Storazzo::RicDiskConfig.load(): END " if verbose
        end

        def config_ver
            #self.
            @config['ConfigVersion']
        end
        def config_default_folder
            #self.
            @config['Config']['DefaultFolder'] #rescue "Unknown config_default_folder: #{$!}"
        end

        def to_s
            size =  File.size @config_file 
            "RicDiskConfig(v#{config_ver}, file=#{ @config_file}) with #{size} bytes" # - config_default_folder=#{self.config_default_folder}"
        end

        def get_config(opts={})
            return load(opts) if @config.nil?
            @config
        end

        def self.gem_default_config_path
            Storazzo.root + "/etc/storazzo_config.sample.yaml"
        end

        # UGLY CODE, copipasted from binary for ARGV, ex autosbrodola
        def iterate_through_file_list_for_disks(files_list=[])
            if files_list == [] # or files_list.nil?  # empty -> ALL
                deb "iterate_through_file_list_for_disks(): no args provided"
                dirs = RicDisk.find_active_dirs()
                puts "DEB find_active_dirs: #{green dirs}"
                dirs.each {|dir| 
                    RicDisk.write_config_yaml_to_disk(dir)
                    RicDisk.calculate_stats_files(dir) # dir is inutile
                } # TODO refactor in option sbrodola_afterwards=true. :)
            else
                deb "iterate_through_file_list_for_disks(): I consider files_list as a list of directories to parse :)"
                dirs = RicDisk.find_active_dirs()
                files_list.each do |dir| 
                    dir = File.expand_path(dir)
                    if dirs.include?(dir)
                        deb "Legit dir: #{green dir}"
                        RicDisk.write_config_yaml_to_disk(dir)
                        RicDisk.calculate_stats_files(dir) # dir is inutile
                    else
                        deb "Figghiu ri buttana: doesnt exist #{red dir}" 
                    end
                end
            end
        end #/iterate_through_file_list_for_disks
        
    end
end
