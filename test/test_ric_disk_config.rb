=begin
    to just test this file, try:
    
    `ruby -I test test/test_ric_disk_config.rb`   
    
=end

require "minitest/autorun"
require "storazzo"
#require "storazzo/ric_disk_config"
#require "storazzo/ric_disk_sample_config"
#require "storazzo/ric_disk_config_example"

# require "storazzo/media/local_folder"
#require "storazzo/ric_disk/gcs_bucket"
#require "storazzo/media/local_folder"


class RicDiskConfigTest < Minitest::Test

    def test_load_sample_version # test_sample_config_is_within_gems_boundaries
        #config_obj = Storazzo::RicDiskConfig.instance()
        #puts :sofar_so_good
        config_obj = Storazzo::RicDiskSampleConfig.instance()
        puts "config_obj.class: #{config_obj.class}"
        l = config_obj.load # _sample_version
        puts l
        #puts '[RicDiskConfigTest] TODO lets make sure the gem being imported is actually in /etc/storazz-config.smaple blah blah'
        #puts "[RicDiskConfigTest] config_file: ", config_obj.config_file
        assert_equal(
            config_obj.config_file,
            "etc/",
            "Config file expected to be here.."
        )
    end


end