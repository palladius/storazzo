# frozen_string_literal: true

require 'minitest/autorun'
require 'storazzo'

class RicDiskTest < Minitest::Test
  def test_factory_works_for_gcs
    # actual_list = Storazzo::Media::GcsBucket.list_all($sample_config_obj)
    rd1 = Storazzo::RicDisk.new('Doesnt accept a string, should be a Gcs Something... Plus why is this test here and not under TestGcsBucket?!?')
    hash = rd1.to_verbose_s
    pp hash
    assert_equal(
      hash.class,
      Hash,
      'rd1.to_verbose_s should return a Hash'
    )
  end
end
