=begin
    to just test this file, try:

    `ruby -I test test/test_ric_disk_config.rb`

=end

require "minitest/autorun"
require "storazzo"

class RicDiskConfigTest < Minitest::Test
  include Storazzo::Common

  def test_load_sample_version # test_sample_config_is_within_gems_boundaries
    # config_obj = Storazzo::RicDiskConfig.instance()
    # puts :sofar_so_good
    config_obj = Storazzo::RicDiskSampleConfig.instance()
    puts "config_obj.class: #{config_obj.class}"
    config = config_obj.load # _sample_version
    pverbose $DEBUG, "[test_load_sample_version] Config: #{pp config}"
    # puts '[RicDiskConfigTest] TODO lets make sure the gem being imported is actually in /etc/storazz-config.smaple blah blah'
    # puts "[RicDiskConfigTest] config_file: ", config_obj.config_file
    assert_equal(
      config_obj.config_file,
      Storazzo.root + "/etc/storazzo_config.sample.yaml",
      "Config file expected to be here.."
    )
  end
end
