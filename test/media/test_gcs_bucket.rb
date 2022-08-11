# frozen_string_literal: true

require 'minitest/autorun'
require 'storazzo'
require 'storazzo/ric_disk'
require 'storazzo/ric_disk_config'
require 'storazzo/colors'
# require "storazzo/media/local_folder"
require 'storazzo/media/gcs_bucket'

require 'pry' # must install the gem... but you ALWAYS want pry installed anyways

# TEST: watch rake test TEST="test/media/test_gcs_bucket.rb"

class GcsBucketTest < Minitest::Test
  include Storazzo::Common

  # tear_up
  def setup
    deb '[GcsBucketTest] TEAR_UP with sample Config'
    # removeme = Storazzo::RicDiskConfig.instance()
    @sample_config_obj = Storazzo::RicDiskSampleConfig.instance
    @sample_config_hash = @sample_config_obj.load
    deb "[GcsBucketTest] TEAR_UP config_obj: '''#{@sample_config_obj}'''"
  end

  def test_that_test_buckets_are_the_two_I_know
    # copied from etc/sample.yaml :)
    expected_test_buckets_list = %w[
      gs://my-local-backup/storazzo/backups/
      gs://my-other-bucket/
    ]
    actual_list = Storazzo::Media::GcsBucket.list_all(@sample_config_obj)
    assert_equal(
      expected_test_buckets_list.sort,
      actual_list.sort,
      'These are the two lists from Sample Storazzo Config'
    )
  end

  def test_import_sample_class_correctly
    # require "storazzo/ric_disk_sample_config" rescue nil
    # require "storazzo/ric_disk_config"

    # puts Storazzo.class
    deb " Storazzo.constants: #{Storazzo.constants}"
    # puts Storazzo::RicDiskSampleConfig
    # config_obj = Storazzo::RicDiskSampleConfig.instance()
    if_deb? do
      Pry::ColorPrinter.pp(@sample_config_obj.to_verbose_s)
    end
    # pp green(config_obj.to_verbose_s())

    l = @sample_config_obj.load
    Pry::ColorPrinter.pp(l) if $DEBUG

    puts "@sample_config_obj: #{@sample_config_obj}"
    # config_obj.load # _sample_version
  end

  def test_super_duper_list_works
    # we had a problem on GCS side
    # Storazzo::Media::AbstractRicDisk.super_duper_list_all_with_type
    expected_ret = [
      [:config_gcs_bucket, 'gs://my-local-backup/storazzo/backups/'],
      [:config_gcs_bucket, 'gs://my-other-bucket/']
    ]
    ret = Storazzo::Media::GcsBucket.list_all_with_type
    Pry::ColorPrinter.pp(ret)
    assert_equal(
      ret.class,
      Array,
      'test_super_duper_list_all_with_type_returns_something should return an array..'
    )
    assert_equal(ret, expected_ret, 'These are the two buckets I expect from test..')
  end

  def test_gsutil_returns_something
    ret = Storazzo::Media::GcsBucket.list_available_buckets
    Pry::ColorPrinter.pp(ret)
  end

  # def test_super_duper_list_all_with_type_returns_something
  #   deb "This would be already... something :) it means they're all implemented"
  #   ret = Storazzo::Media::AbstractRicDisk.super_duper_list_all_with_type
  #   assert(
  #     ret.class,
  #     Array,
  #     "test_super_duper_list_all_with_type_returns_something should return an array.."
  #   )
  # end
end
