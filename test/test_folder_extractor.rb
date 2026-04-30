# frozen_string_literal: true

require 'minitest/autorun'
require 'storazzo'
require 'storazzo/stats/folder_extractor'

class FolderExtractorTest < Minitest::Test
  def setup
    @sample_rds_content = <<~RDS
      [file_v1.2] md5_1 100644 f 2024-01-01T12:00:00Z 1000 [text/plain] ./folder_a/file1.txt
      [file_v1.2] md5_2 100644 f 2024-01-01T12:00:00Z 2000 [text/plain] ./folder_a/file2.txt
      [file_v1.2] md5_3 100644 f 2024-01-01T12:00:00Z 5000 [text/plain] ./folder_b/sub/file3.txt
      [file_v1.2] md5_4 100644 f 2024-01-01T12:00:00Z 500 [text/plain] ./file4.txt
      [file_v1.2] md5_5 100644 f 2024-01-01T12:00:00Z 100 [text/plain] ./folder_c/file5.txt
      [file_v1.2] md5_6 100644 f 2024-01-01T12:00:00Z 100 [text/plain] ./folder_c/file6.txt
      [file_v1.2] md5_7 100644 f 2024-01-01T12:00:00Z 100 [text/plain] ./folder_c/file7.txt
    RDS
    
    @tmp_rds_file = "/tmp/test_extractor.rds"
    File.write(@tmp_rds_file, @sample_rds_content)
  end

  def teardown
    File.delete(@tmp_rds_file) if File.exist?(@tmp_rds_file)
  end

  def test_extract_top_folders_by_size
    extractor = Storazzo::Stats::FolderExtractor.new(@tmp_rds_file)
    top_folders = extractor.top_folders_by_size(2)
    
    # folder_b/sub: 5000
    # folder_a: 3000 (1000 + 2000)
    # folder_c: 300
    # .: 500
    
    assert_equal "folder_b/sub", top_folders[0][:path]
    assert_equal 5000, top_folders[0][:size]
    assert_equal "folder_a", top_folders[1][:path]
    assert_equal 3000, top_folders[1][:size]
  end

  def test_extract_top_folders_by_count
    extractor = Storazzo::Stats::FolderExtractor.new(@tmp_rds_file)
    top_folders = extractor.top_folders_by_count(2)
    
    # folder_c: 3
    # folder_a: 2
    # folder_b/sub: 1
    # .: 1
    
    assert_equal "folder_c", top_folders[0][:path]
    assert_equal 3, top_folders[0][:count]
    assert_equal "folder_a", top_folders[1][:path]
    assert_equal 2, top_folders[1][:count]
  end
end
