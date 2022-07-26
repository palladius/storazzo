require "minitest/autorun"
require "storazzo"
require "storazzo/ric_disk"
require "storazzo/media/local_folder"

#require "storazzo/ric_disk/gcs_bucket"
#require "storazzo/media/local_folder"

class LocalFolderTest < Minitest::Test
    # def test_fail_on_purpOSE # test_storazzo_hi_with_argument
    #     assert_match 42, 42 , "change me when it failes from makefile" 
    #     #"Hello from Storazzo", Storazzo::Main.hi("ruby this should fail")
    #     #assert_match "ruby this should fail", Storazzo::Main.hi("ruby this should fail")
    # end
    def tear_up 
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

    # def test_first_directory_parsing_actually_works()
    #     # include module 
    #     puts "WEIRD THING: This test is flaky"

    #     folders = Storazzo::Media::LocalFolder.list_all

    #     test_dir = folders.first
    #     puts "test_first_directory_parsing_actually_works() TestDir: #{test_dir}"
    #     #myclass = LocalFolder
    #     puts "TEST S:M:LF methods: #{folders}"  # methods
    #     disk = Storazzo::Media::LocalFolder.new(test_dir)
    #     stats_file = disk.stats_filename_default_fullpath
    #     puts "stats_file: #{stats_file}"
    #     disk.parse()
    #     assert(
    #         File.exists?(stats_file),
    #         "parse on LocalFolder should create file '#{stats_file}'"
    #         )
    # end
end