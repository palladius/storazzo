# frozen_string_literal: true

require 'minitest/autorun'
require 'storazzo'
require 'fileutils'
require 'storazzo/stats/file_service'

class FileServiceTest < Minitest::Test
  def setup
    @test_file = 'test_file.txt'
    File.write(@test_file, 'Hello Storazzo!')
  end

  def teardown
    FileUtils.rm_f(@test_file)
  end

  def test_compute_stats_returns_valid_data
    data = Storazzo::Stats::FileService.compute_stats(@test_file)
    assert_equal 'file_v1.2', data[:entity_type]
    assert_equal Digest::MD5.hexdigest('Hello Storazzo!'), data[:md5]
    assert_match(/1006/, data[:mode]) # file mode
    assert_equal 'f', data[:file_type]
    assert_equal 'text/plain', data[:content_type]
    assert_equal 15, data[:size]
    assert_equal @test_file, data[:path]
  end

  def test_format_rds_line
    data = {
      entity_type: 'file_v1.2',
      md5: 'abc123def',
      mode: '100644',
      file_type: 'f',
      mtime: '2024-01-01T12:00:00Z',
      size: 100,
      content_type: 'text/plain',
      path: './my_file.txt'
    }
    line = Storazzo::Stats::FileService.format_rds_line(data)
    expected = "[file_v1.2] abc123def 100644 f 2024-01-01T12:00:00Z        100 [text/plain] ./my_file.txt"
    assert_equal expected, line
  end
end
