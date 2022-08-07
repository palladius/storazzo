require 'singleton'
require 'yaml'

# require 'storazzo/media/abstract_ric_disk'
Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each do |file|
  require File.basename(file, File.extname(file))
end
# require_all 'media/directory'

=begin
    This is a singleton class. You call me this way..
    You call me with:

    Storazzo::RicDiskConfig.instance()

    or better

    Storazzo::RicDiskConfig.safe_instance()

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

    DefaultConfigLocation = File.expand_path "~/.storazzo.yaml"

    DefaultConfigLocations = [
      File.expand_path("~/.storazzo.yaml"), # HOME
      File.expand_path("./.storazzo.yaml"), # LOCAL DIR
    ]

    DefaultGemLocationForTests =
      File.expand_path('../../../', __FILE__) +
      "/etc/storazzo_config.sample.yaml"

    attr_accessor :config, :config_file, :load_called, :project_id

    public

    # Load from the first valid config.
    def load(config_path = nil, opts = {})
      verbose = opts.fetch :verbose, false

      if already_loaded? # and not self.config.nil?
        pverbose verbose, "[#{self.class}] VERBOSE load: already loaded"
        return self.config
      end
      pverbose verbose, "Storazzo::RicDiskConfig.load(): BEGIN"
      # trying default location
      raise "DefaultConfigLocation is not a string" unless DefaultConfigLocation.is_a?(String)

      possible_locations = DefaultConfigLocations #  [ default_config_locations .. , "./.storazzo.yaml"]
      deb "[Config.load] Possible Locations: #{possible_locations}"
      if config_path.is_a?(String)
        # possible_locations = [config_path] + possible_locations # .append()
        possible_locations = possible_locations.unshift(config_path) # append to front
        # OR: possible_locations.instert(0, config_path)
        pverbose verbose, "[LOAD] possible_locations: #{possible_locations}"
      end
      puts "[VERBOSE] Searching these paths in order: #{possible_locations}" if verbose
      # bug "This is not always an array of sTRINGS."
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
          # pp @config if verbose
          config_ver = @config["apiVersion"]
          # puts @config[:ConfigVersion]
          deb("OK. Storazzo::RicDiskConfig v'#{config_ver}' parsed correctly")
          # puts "[VERBOSE] RicDiskConfig.to_s: #{self}" if verbose
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
      raise "DEPRECATED! USE SampleRicDiskConfig.load() instead!"
    end

    def config_ver
      raise "I cant compute Version since I cant compute @config. Are you sure you didnt instance this Singleton without calling load?" if @config.nil?

      @config['apiVersion'] # rescue :StillUnknown
      # config['ConfigVersion']
    end

    def config_default_folder
      # self.
      @config['Config']['DefaultFolder'] # rescue "Unknown config_default_folder: #{$!}"
    end

    def config_project_id
      @config['Config']['Backends']['GoogleCloudStorage']['ProjectId']
    end

    #doesnt work :/ alias :project_id, :config_project_id
    def project_id
      config_project_id
    end

    def already_loaded?
      # return
      load_called == true
    end

    def to_s
      size = File.size(@config_file) rescue -1
      # puts yellow "DEB: #{@config["apiVersion"]}"
      # "RicDiskConfig(ver=#{config_ver}, file=#{config_file}), #{white(size)} bytes" # - config_default_folder=#{self.config_default_folder}"
      "POLY_#{self.class}_(ver=#{config_ver}, file=#{config_file}), #{white(size)} bytes" # - config_default_folder=#{self.config_default_folder}"
    end

    def to_verbose_s
      h = {}
      h[:description] =
        "This is a Verbose Hash describing a RicDiskConfig or its child RicDiskSampleConfig to understand why it keeps failing.."
      h[:to_s] = self.to_s
      h[:class] = self.class
      h[:file] = __FILE__
      h[:id] = self.object_id
      h[:get_bucket_paths] = self.get_bucket_paths()
      h[:get_local_folders] = self.get_local_folders()
      h[:config_project_id] = self.config_project_id()
      return h
    end

    def get_config(opts = {})
      return load(opts) if @config.nil?

      @config
    end

    def self.gem_default_config_path
      Storazzo.root + "/etc/storazzo_config.sample.yaml"
    end

    # Storazzo::RicDiskConfig

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
      # puts config['Config']['AdditionalMountDirs']
      config['Config']['AdditionalMountDirs'].map { |folder|
        File.expand_path(folder) rescue folder # TypeError: no implicit conversion of Hash into String
      }.filter { |f| File.directory?(f) }
    end

    def get_bucket_paths
      get_config['Config']['Backends']['GoogleCloudStorage']['BucketPaths'].map { |complex_gcs_struct|
        complex_gcs_struct['path']
      }
    end

    # UGLY CODE, copipasted from binary for ARGV, ex autosbrodola
    def iterate_through_file_list_for_disks(files_list = [], opts = {})
      verbose = opts.fetch :verbose, false
      raise "[iterate_through_file_list_for_disks] Wrong input, I need an array here: #{files_list} " unless files_list.is_a?(Array)

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
      puts "iterate_through_file_list_for_disks(): I consider files_list as a list of directories to parse :)" if verbose

      # dirs = RicDisk.find_active_dirs()
      files_list.each do |dir|
        dir = File.expand_path(dir)
        if File.directory?(dir)
          # if dirs.include?(dir)
          puts "iterate_through_file_list_for_disks() Legit dir: #{green dir}" if verbose
          rd = RicDisk.new(Storazzo::Media::AbstractRicDisk.DirFactory(dir))
          pverbose true, "RicDisk from Factory (woohoo): #{rd}"
          rd.write_config_yaml_to_disk(dir)
          # RicDisk.write_config_yaml_to_disk(dir)
          # RicDisk.calculate_stats_files (CLASS) => will become OBJECT compute_stats_files
          rd.compute_stats_files() # dir is inutile # TODO
        else
          raise("Doesnt seem a dir to me, quitting: #{dir}")
        end
      end
      # end
    end # /iterate_through_file_list_for_disks

    def config_hash
      config['Config']
    end

    def self.safe_instance()
      puts "This is a safe instance :)"
      my_config = self.instance()
      my_config.load
      my_config
    end

    def self.get_config
      self.instance.load unless self.instance.load_called
      self.instance.get_config
    end

    # # gem 'after_do'
    # require 'after_do'
    # Storazzo::RicDiskConfig.extend AfterDo
    # Storazzo::RicDiskConfig.after :instance do # |activity|  #:pause, :finish, :resurrect, :do_today, :do_another_day
    #     puts yellow("after INSTANCE() has been called I call LOAD!!!")
    #     self.load
    #     #persistor.save activity
    # end
  end #     class Storazzo::RicDiskConfig
end # module Storazzo
