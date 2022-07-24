require "minitest/autorun"
require "storazzo"
require "storazzo/ric_disk"
#require "storazzo/media"
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
        puts Storazzo::Media::LocalFolder.list_all
    end

    def test_list_all_returns_an_array_of_real_directories
        dirs = Storazzo::Media::LocalFolder.list_all
        dirs.each{ |dir|
            assert_equal(String, dir, "Dir should be a String representing an existing directory")
            assert(File.directory?(dir), "Dir should be a file of type 'directory'")
        }
    end

    def test_first_directory_parsing_actually_works()
        test_dir = Storazzo::Media::LocalFolder.list_all.first
        puts "TestDir: #{test_dir}"
        disk = Storazzo::Media::LocalFolder.new test_dir
        disk.parse()
        # some tests on parsed file.
        assert(File.exists?(disk.stats_file_default_location))
    end
end