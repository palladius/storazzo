require 'singleton'
require 'yaml'

=begin
    This is a singleton class. You call me this way..
    You call me with:

    Storazzo::RicDiskConfig.instance()

    Note that being a Singleton, in Unit Tests it's hard to use the /etc/storazzo_config.sample.yaml instead
    of the real one - yiikes. How do I fix it? Do I unsingleton it? :) Or do I create TWO singletons? :)
=end

module Storazzo
    # class Storazzo::Blah
    # end

    class Storazzo::RicDiskConfig
        include Singleton
        include Storazzo::Common
        include Storazzo::Colors
        
        #@@default_config_location = "~/.storazzo.yaml" 
        DefaultConfigLocation = File.expand_path "~/.storazzo.yaml" 
        # @@default_config_locations = [
        #     "~/.storazzo.yaml" , # HOME
        #     "./.storazzo.yaml" , # LOCAL DIR
        # ]        
        DefaultConfigLocations = [
            File.expand_path("~/.storazzo.yaml") , # HOME
            File.expand_path("./.storazzo.yaml") , # LOCAL DIR
        ]
        #@@default_gem_location_for_tests
        DefaultGemLocationForTests = File.expand_path('../../../', __FILE__) + "/etc/storazzo_config.sample.yaml" 
        
        attr_accessor :config, :config_file, :load_called

public
        # Load from the first valid config.
        def load(config_path=nil, opts={})
            verbose = opts.fetch :verbose, false

            puts "[VERBOSE] Storazzo::RicDiskConfig.load(): BEGIN " if verbose
            # trying default location
            raise "DefaultConfigLocation is not a string" unless DefaultConfigLocation.is_a?(String)
            possible_locations = DefaultConfigLocations  #  [ @@default_config_location , "./.storazzo.yaml"]
            puts "DEB possible_locations: #{possible_locations}"
            if config_path.is_a?(String) 
                #possible_locations = [config_path] + possible_locations # .append() 
                possible_locations = possible_locations.unshift(config_path) # append to front
                #OR: possible_locations.instert(0, config_path)
                puts "[LOAD] possible_locations: #{possible_locations}" if verbose
            end
            puts "[VERBOSE] Searching these paths in order: #{possible_locations}" if verbose
            bug "This is not always an array of sTRINGS."
            raise "possible_locations is not an array" unless possible_locations.is_a?(Array)
            possible_locations.each do |possible_path|
                # ASSERT is a string
                raise "possible_path is not a string" unless possible_path.is_a?(String)
                deb "before buggy expand_path paz: '#{possible_path}''"
                paz = File.expand_path(possible_path) rescue possible_path
                raise "Not a string: #{paz}" unless paz.is_a?(String)
                if File.exists?(paz)
                    @config_file = paz 
                    @config = YAML.load(File.read paz) # YAML.load(File.read("file_path"))

                    unless (@config["kind"] == 'StorazzoConfig' rescue false)
                        puts white "RicDiskConfig.load(): Sorry this is wrong Config File. Kind=#{@config["kind"] rescue $!}"
                        next
                    end
                    #
                    #pp @config if verbose
                    config_ver = @config["apiVersion"]
                    #puts @config[:ConfigVersion]
                    puts white("OK. Storazzo::RicDiskConfig v'#{config_ver}' parsed correctly")
                    puts "[VERBOSE] RicDiskConfig.to_s: #{self}" if verbose
                    @load_called = true
                    return self.config
                end
            end
            @load_called = true
            # only get here if nothing is found
            raise "No config found across these locations: #{possible_locations}. Consider copying and editing: #{RicDiskConfig.gem_default_config_path}"
        end

        # Obsolete, call another class instead.
        def load_sample_version
        #     puts("Warning! We're destroying the world here. We're taking a Singletong and changing the way it behaves by moving the config file by under her feet. Don't be mad at me if this misbehaves. You saw it coming, my friends. This is why I would NEVER hire you as a Software Developer in my Company.")
             raise "DEPRECATED! USE SampleRicDiskConfig.load() instead!"
        #     load(DefaultGemLocationForTests, :verbose => true )
        end

        def config_ver
            raise "I cant compute Version since I cant compute @config. Are you sure you didnt instance this Singleton without calling load?" unless @config
            @config['apiVersion'] # rescue :StillUnknown
            #config['ConfigVersion']
        end
        def config_default_folder
            #self.
            @config['Config']['DefaultFolder'] #rescue "Unknown config_default_folder: #{$!}"
        end

        def to_s
            size = File.size(@config_file) rescue -1
            #puts yellow "DEB: #{@config["apiVersion"]}"
            #"RicDiskConfig(ver=#{config_ver}, file=#{config_file}), #{white(size)} bytes" # - config_default_folder=#{self.config_default_folder}"
            "POLY_#{self.class}_(ver=#{config_ver}, file=#{config_file}), #{white(size)} bytes" # - config_default_folder=#{self.config_default_folder}"
        end

        def get_config(opts={})
            return load(opts) if @config.nil?
            @config
        end

        def self.gem_default_config_path
            Storazzo.root + "/etc/storazzo_config.sample.yaml"
        end


        # returns all folders from file which are Directories
        # This method is FLAKY! Sometimes gives error.
#         LocalFolderTest#test_show_all_shouldnt_fail_and_should_return_a_non_empty_array:
# TypeError: no implicit conversion of Hash into String
#     /Users/ricc/git/storazzo/lib/storazzo/ric_disk_config.rb:38:in `expand_path'
#     /Users/ricc/git/storazzo/lib/storazzo/ric_disk_config.rb:38:in `block in load'
#     /Users/ricc/git/storazzo/lib/storazzo/ric_disk_config.rb:37:in `each'
#     /Users/ricc/git/storazzo/lib/storazzo/ric_disk_config.rb:37:in `load'
#     /Users/ricc/git/storazzo/lib/storazzo/ric_disk_config.rb:83:in `get_config'
#     /Users/ricc/git/storazzo/lib/storazzo/ric_disk_config.rb:95:in `get_local_folders'
        def get_local_folders
            config = get_config
            #puts config['Config']['AdditionalMountDirs']
            config['Config']['AdditionalMountDirs'].map{|folder|
                File.expand_path(folder) rescue folder # TypeError: no implicit conversion of Hash into String
        }.filter{|f| File.directory?(f)}
        end

        def get_bucket_paths
            get_config['Config']['Backends']['GoogleCloudStorage']['BucketPaths'].map{|complex_gcs_struct| complex_gcs_struct['path']}
        end

        # UGLY CODE, copipasted from binary for ARGV, ex autosbrodola
        def iterate_through_file_list_for_disks(files_list=[])
            # I decided i wont accept an emopty list, this is not how you use the gem, you lazy XXX!
            # if files_list == [] # or files_list.nil?  # empty -> ALL
            #     deb "iterate_through_file_list_for_disks(): no args provided"
            #     dirs = RicDisk.find_active_dirs()
            #     puts "DEB find_active_dirs: #{green dirs}"
            #     dirs.each {|dir| 
            #         RicDisk.write_config_yaml_to_disk(dir)
            #         RicDisk.calculate_stats_files(dir) # dir is inutile
            #     } # TODO refactor in option sbrodola_afterwards=true. :)
            # else
                deb "iterate_through_file_list_for_disks(): I consider files_list as a list of directories to parse :)"
                #dirs = RicDisk.find_active_dirs()
                files_list.each do |dir| 
                    dir = File.expand_path(dir)
                    if File.directory?(dir)
                    #if dirs.include?(dir)
                        deb "iterate_through_file_list_for_disks() Legit dir: #{green dir}"
                        rd = RicDisk.new(dir)
                        rd.write_config_yaml_to_disk(dir)
                        #RicDisk.write_config_yaml_to_disk(dir)
                        RicDisk.calculate_stats_files(dir) # dir is inutile
                    else
                        deb red("Doesnt seem a legit dir to me: #{dir}")
                    #     deb "Figghiu ri buttana: doesnt exist #{red dir}" 
                    end
                end
            #end
        end #/iterate_through_file_list_for_disks
        

        def self.get_config 
            self.instance.get_config
        end
    end #     class Storazzo::RicDiskConfig

    # class Storazzo::SampleRicDiskConfig < Storazzo::RicDiskConfig
    #     include Singleton

    #     def load # _sample_version
    #         puts white("Wheew! We're NOT destroying the world here. We're actually instancing a second Singleton which is a child of the mother, and this time doing things nicely and Rubily.")
    #         super.load(DefaultGemLocationForTests, :verbose => true )
    #     end

    # end

    puts "[REMOVEME]1 Storazzo::RicDiskConfig was read"

#end # module Storazzo

puts "[REMOVEME]2 Storazzo::RicDiskConfig was read"



#module Storazzo
    
    # ric_disk_sample_config
    #class Pincopallo # Storazzo::Blah #RicDiskSampleConfig #  < Storazzo::RicDiskConfig
    class Storazzo::Pincopallo # RicDiskSampleConfig

    #include Singleton
    # public
    #     def load # _sample_version
    #         puts white("Wheew! We're NOT destroying the world here. We're actually instancing a second Singleton which is a child of the mother, and this time doing things nicely and Rubily.")
    #         super.load(DefaultGemLocationForTests, :verbose => true )
    #     end
    end

    puts "[REMOVEME]1 Storazzo::RicDiskSampleConfig was read"
end # module Storazzo

puts "[REMOVEME]2 Storazzo::RicDiskSampleConfig was read"
