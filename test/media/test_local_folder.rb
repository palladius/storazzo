require "minitest/autorun"
require "storazzo"
require 'storazzo/common'
require "storazzo/ric_disk"
require "storazzo/ric_disk_config"
require 'storazzo/colors'
require "storazzo/media/local_folder"

class LocalFolderTest < Minitest::Test
#    include Storazzo::Colors
#    include Storazzo::Common
    include Storazzo::Common

    # def test_fail_on_purpOSE # test_storazzo_hi_with_argument
    #     assert_match 42, 42 , "change me when it failes from makefile" 
    #     #"Hello from Storazzo", Storazzo::Main.hi("ruby this should fail")
    #     #assert_match "ruby this should fail", Storazzo::Main.hi("ruby this should fail")
    # end
    def tear_up 
        include Storazzo::Colors
        puts yellow("LocalFolderTest: tear up")
        #$config_useless = Storazzo::RicDiskConfig.instance()
        $config = Storazzo::RicDiskSampleConfig.instance()
        $config_load = $config.load()
        puts $config.to_verbose_s
        
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
    def TODO_test_1_first_directory_parsing_actually_works()
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
        deb "config: ''#{config}''"
        # config.iterate_through_file_list_for_disks([test_dir])
        # assert(
        #     File.exists?(stats_file),
        #     "parse on LocalFolder should create file '#{stats_file}'"
        # )
    end

    def test_vars_transporeted_across_teraup_and_tests
        puts $config_load
        puts $config
    end

    def test_2_iterate_through_file_list_for_disks
        #puts("(#{__FILE__}) WEIRD THING: This test is flaky. SKipping for now until I complete the LocalFolder.parse() code")
        folders = Storazzo::Media::LocalFolder.list_all
        puts "Folders: #{folders}"
        config = Storazzo::RicDiskSampleConfig.instance()
        config.load
        puts "config1: #{config}"
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

    def TODO_test_readonly_directory_creates_configfile_outside_of_dir
        test_dir = "/etc/"
        disk = Storazzo::Media::LocalFolder.new(test_dir)
        stats_file = disk.stats_filename_default_fullpath
        config = Storazzo::RicDiskSampleConfig.instance()
        config.load
        config.iterate_through_file_list_for_disks([test_dir])
        assert(
            not(File.exists?(stats_file)),
            "parse on LocalFolder should NOT create file '#{stats_file}' but another in another TODO place"
        )
        # ...
    end

    def test_readonly_directory_is_indeed_readonly
        test_dir = "/etc/"
        readonly_rdisk = Storazzo::Media::LocalFolder.new(test_dir)
        if_deb? do
            ppp(readonly_rdisk.to_verbose_s) 
        end
        assert_equal(
            readonly_rdisk.wr,
            false,
            "Folder #{test_dir} is NOT writeble to the author's knowledge."
        )
        # ...
    end


    def test_writeable_tmp_directory_is_indeed_writeable
        test_dir = '/tmp/'
        #test_dir = '~'
        writeable_rdisk = Storazzo::Media::LocalFolder.new(test_dir)
        #writeable_rdisk = Storazzo::RicDisk.new(test_dir)
        if_deb?{ ppp(writeable_rdisk.to_verbose_s) }
        assert_equal(
            true,
            writeable_rdisk.wr,
            "Folder #{test_dir} is INDEED writeble to the author's knowledge, although triggers lot of noise => wr=#{ writeable_rdisk.wr }"
        )
    end


end