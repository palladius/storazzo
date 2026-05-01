# frozen_string_literal: true

require 'minitest/autorun'
require 'mocha/minitest'
require 'tmpdir'
require 'storazzo'
require 'storazzo/media/local_folder'

class RicDiskSummarizationTest < Minitest::Test
  def setup
    @tmp_dir = Dir.mktmpdir
    @rds_file = File.join(@tmp_dir, "ricdisk_stats_v11.rds")
    @summary_file = File.join(@tmp_dir, "storazzo.yaml")
    
    # Create a dummy .rds file
    File.write(@rds_file, "[file_v1.2] md5 100644 f 2024-01-01T12:00:00Z 1000 [text/plain] ./test/file.txt\n")
    
    # Use real LocalFolder
    @ard = Storazzo::Media::LocalFolder.new(@tmp_dir)
    @ric_disk = Storazzo::RicDisk.new(@ard)
  end

  def teardown
    FileUtils.remove_entry @tmp_dir
  end

  def test_generate_summary_yaml_creates_file
    # Mock FolderExtractor
    mock_extractor = mock()
    Storazzo::Stats::FolderExtractor.stubs(:new).with(@rds_file).returns(mock_extractor)
    mock_extractor.stubs(:top_folders_by_size).returns([{ path: "test", size_human: "1 KB", size: 1000 }])
    mock_extractor.stubs(:top_folders_by_count).returns([{ path: "test", count: 1 }])
    
    # Mock GeminiSummarizer
    mock_summarizer = mock()
    Storazzo::LLM::GeminiSummarizer.stubs(:new).returns(mock_summarizer)
    mock_summarizer.stubs(:summarize_disk).returns({
      "llm_description" => "A test summary",
      "llm_storage_type" => "Mock",
      "llm_categorization" => "Tests",
      "llm_tags" => ["test"]
    })

    @ric_disk.generate_summary_yaml
    
    assert File.exist?(@summary_file)
    yaml_content = YAML.load_file(@summary_file)
    assert_equal "A test summary", yaml_content["llm_description"]
  end
end
