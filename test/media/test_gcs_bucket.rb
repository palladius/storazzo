require "minitest/autorun"
require "storazzo"
require "storazzo/ric_disk"
require "storazzo/ric_disk_config"
require 'storazzo/colors'
require "storazzo/media/local_folder"
require "storazzo/ric_disk_config_example"

require 'pry' # must install the gem... but you ALWAYS want pry installed anyways


class GcsBucketTest < Minitest::Test

    include Storazzo::Common

    def setup # tear_up 
        deb "[GcsBucketTest] TEAR_UP with sample Config"
        #removeme = Storazzo::RicDiskConfig.instance()
        $sample_config_obj = Storazzo::RicDiskSampleConfig.instance()
        $sample_config_hash = $sample_config_obj.load()
        deb "[GcsBucketTest] TEAR_UP config_obj: '''#{$sample_config_obj}'''"
    end

    def test_buckets_are_the_two_i_know
        # copied from etc/sample.yaml :)
        expected_list = %w{
            gs://my-local-backup/storazzo/backups/
            gs://my-other-bucket/
        }
        actual_list = Storazzo::RicDisk::GcsBucket.list_all($sample_config_obj)
        assert_equal(
            expected_list.sort, 
            actual_list.sort,
            "These are the two lists from Sample Storazzo Config")
    end

    def test_import_sample_class_correctly
        #require "storazzo/ric_disk_sample_config" rescue nil
        #require "storazzo/ric_disk_config"

        #puts Storazzo.class
        deb " Storazzo.constants: #{ Storazzo.constants}"
        #puts Storazzo::RicDiskSampleConfig
        #config_obj = Storazzo::RicDiskSampleConfig.instance()
        Pry::ColorPrinter.pp($sample_config_obj.to_verbose_s())
        #pp green(config_obj.to_verbose_s())

        l = $sample_config_obj.load
        Pry::ColorPrinter.pp(l)

        puts "$sample_config_obj: #{$sample_config_obj}"
        #config_obj.load # _sample_version
    end


    # def teardown
    #     puts :TEAR_DOWN_TODO
    # end

end