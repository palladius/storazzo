# frozen_string_literal: true

require 'minitest/autorun'
require 'storazzo'
require 'storazzo/stats/file_service'

class MimeOptimizationTest < Minitest::Test
  def setup
    @image_file = 'test_image.png'
    File.write(@image_file, "\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01")
    @ruby_file = 'test_script.rb'
    File.write(@ruby_file, '# frozen_string_literal: true')
  end

  def teardown
    FileUtils.rm_f(@image_file)
    FileUtils.rm_f(@ruby_file)
  end

  def test_compute_stats_uses_native_mime_for_png
    data = Storazzo::Stats::FileService.compute_stats(@image_file)
    assert_equal 'image/png', data[:content_type]
  end

  def test_compute_stats_uses_native_mime_for_ruby
    data = Storazzo::Stats::FileService.compute_stats(@ruby_file)
    # Different libraries might return text/x-ruby or application/x-ruby
    assert_match(/ruby/, data[:content_type])
  end
end
