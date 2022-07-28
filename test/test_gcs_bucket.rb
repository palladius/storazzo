require "minitest/autorun"
require "storazzo"
require "storazzo/ric_disk"
require "storazzo/ric_disk_config"
require 'storazzo/colors'
require "storazzo/media/local_folder"
require "storazzo/ric_disk_config_example"

#require "storazzo/ric_disk_config"
#require "storazzo/ric_disk_sample_config"
#require 'storazzo/ric_disk_sample_config'  # => NOTHING!!
#require 'storazzo/ric_disk_config_sample'  # => NOTHING!!

#require "storazzo/ric_disk"
#require "lib/storazzo/ric_disk_sample_config"
#require "storazzo/media/local_folder"
#require "storazzo/ric_disk/gcs_bucket"
#require "storazzo/media/local_folder"

class GcsBucketTest < Minitest::Test

    include Storazzo::Common

    def TODO_RENAME_MEsetup # tear_up 
        deb "[GcsBucketTest] TEAR_UP with sample Config"
        removeme = Storazzo::RicDiskConfig.instance()
        config_obj = Storazzo::RicDiskSampleConfig.instance()
        deb "[GcsBucketTest] TEAR_UP config_obj: '''#{config_obj}'''"
    end

    def TODO_RENAME_MEtest_buckets_are_the_two_i_know
        expected_list = %w{
            gs://my-local-backup/storazzo/backups/
            gs://my-other-bucket/
        }
        actual_list = Storazzo::RicDisk::GcsBucket.list_all
        assert_equal(expected_list, actual_list,
            "These are the two lists from Sample Storazzo Config")
    end

    def test_import 
        require "storazzo/ric_disk_sample_config" rescue nil
        require "storazzo/ric_disk_config"

        #puts Storazzo.class
        puts Storazzo.constants
        #puts Storazzo::RicDiskSampleConfig
        config_obj = Storazzo::RicDiskSampleConfig.instance()
        puts config_obj
        config_obj.load # _sample_version
    end


    def teardown
        #puts :TEAR_DOWN_TODO
    end

end