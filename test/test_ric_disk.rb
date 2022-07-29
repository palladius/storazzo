require "minitest/autorun"
require "storazzo"

class RicDiskTest < Minitest::Test

    def test_factory_works_for_gcs 
        rd1 = RicDisk.new('/tmp')
        hash = rd1.to_verbose_s()
        pp hash
        assert_equal(
            hash.class,
            Hash,
            "rd1.to_verbose_s should return a Hash" 
        )
    end



end