require "minitest/autorun"
require "storazzo"
require "storazzo/ric_disk"
require "storazzo/media/local_folder"
#require "storazzo/ric_disk/gcs_bucket"
#require "storazzo/media/local_folder"

class GcsBucketTest < Minitest::Test

    def setup # tear_up 
        puts "GcsBucketTest TEAR_UP"
        config_obj = Storazzo::RicDiskConfig.instance()
        config_obj.load_sample_version
    end

    def test_buckets_are_the_two_i_know
        puts :TODO
        expected_list = %w{
            gs://my-local-backup/storazzo/backups/
            gs://my-other-bucket/
        }
        actual_list = Storazzo::RicDisk::GcsBucket.list_all
        assert_equal(expected_list, actual_list,
            "These are the two lists from Sample Storazzo Config")
    end

    def teardown
        puts :TEAR_DOWN_TODO
    end

end