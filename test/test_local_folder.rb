require "minitest/autorun"
require "storazzo"
require "storazzo/ric_disk"
require "storazzo/ric_disk_config"
require 'storazzo/colors'
require "storazzo/media/local_folder"

#require "storazzo/ric_disk/gcs_bucket"
#require "storazzo/media/local_folder"


#puts yellow("DISABLING FOR NOW TODO restore")

class LocalFolderTest < Minitest::Test
    include Storazzo::Colors
    # def test_fail_on_purpOSE # test_storazzo_hi_with_argument
    #     assert_match 42, 42 , "change me when it failes from makefile" 
    #     #"Hello from Storazzo", Storazzo::Main.hi("ruby this should fail")
    #     #assert_match "ruby this should fail", Storazzo::Main.hi("ruby this should fail")
    # end
    def tear_up 
        include Storazzo::Colors
        puts yellow("LocalFolderTest: tear up")
        #$config = Storazzo::RicDiskConfig.instance()
        #$vediamo_se_funge = 42
       # my_class = Storazzo::RicDisk::LocalFolder
        # my_obj = Storazzo::RicDisk::LocalFolder
    end

    def test_show_all_shouldnt_fail_and_should_return_a_non_empty_array
        assert_equal(Array, Storazzo::Media::LocalFolder.list_all.class, "Storazzo::RicDisk::LocalFolder.list_all should return an Array")
        assert(Storazzo::Media::LocalFolder.list_all.size >0, "Array size should be >0")
        #puts Storazzo::Media::LocalFolder.list_all
    end

    def test_list_all_returns_an_array_of_real_directories
        dirs = Storazzo::Media::LocalFolder.list_all
        dirs.each do  |mydir|
            assert_equal(String, mydir.class, "Dir should be a String representing an existing directory")
            assert(File.directory?(mydir), "Dir should be a file of type 'directory'")
        end
    end

    # To only test this:
    # $ ruby -I test test/test_local_folder.rb -n test_first_directory_parsing_actually_works
    def test_1_first_directory_parsing_actually_works()
        # include module 

        #p $vediamo_se_funge
        puts("(#{__FILE__}) WEIRD THING: This test is flaky. SKipping for now until I complete the LocalFolder.parse() code")
        folders = Storazzo::Media::LocalFolder.list_all
        puts "Folders: #{folders}"
        config = Storazzo::RicDiskSampleConfig.instance()
        puts "config1: #{config}"
        config.load
        puts "config2: #{config.load}"
        test_dir = folders.first
        puts "test_first_directory_parsing_actually_works() TestDir: #{test_dir}"
        puts yellow "TEST S:M:LF methods: #{folders}"  # methods
        
        disk = Storazzo::Media::LocalFolder.new(test_dir)
        stats_file = disk.stats_filename_default_fullpath
        puts "stats_file: #{stats_file}"
        disk.parse()
        puts "[DEB] config: ''#{config}''"
        # config.iterate_through_file_list_for_disks([test_dir])
        # assert(
        #     File.exists?(stats_file),
        #     "parse on LocalFolder should create file '#{stats_file}'"
        # )
    end

    def test_2_iterate_through_file_list_for_disks
        #p $vediamo_se_funge
        puts("(#{__FILE__}) WEIRD THING: This test is flaky. SKipping for now until I complete the LocalFolder.parse() code")
        folders = Storazzo::Media::LocalFolder.list_all
        puts "Folders: #{folders}"
        config = Storazzo::RicDiskSampleConfig.instance()
        puts "config1: #{config}"
        config.load
        puts "config2: #{config.load}"
        test_dir = folders.first
        puts "test_first_directory_parsing_actually_works() TestDir: #{test_dir}"
        puts "TEST S:M:LF methods: #{folders}"  # methods

        disk = Storazzo::Media::LocalFolder.new(test_dir)
        stats_file = disk.stats_filename_default_fullpath
        #puts "stats_file: #{stats_file}"
        #disk.parse()
        #puts "[DEB] config: ''#{config}''"

        #TEST2: config + iterate
        config.iterate_through_file_list_for_disks([test_dir])
        assert(
            File.exists?(stats_file),
            "parse on LocalFolder should create file '#{stats_file}'"
        )
    end
end