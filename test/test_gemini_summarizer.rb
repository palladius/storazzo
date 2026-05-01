# frozen_string_literal: true

require 'minitest/autorun'
require 'mocha/minitest'
require 'storazzo'
require 'storazzo/llm/gemini_summarizer'

class GeminiSummarizerTest < Minitest::Test
  def setup
    ENV['GEMINI_API_KEY'] = 'test-api-key'
    @summarizer = Storazzo::LLM::GeminiSummarizer.new('test-api-key')
  end

  def test_summarize_disk_with_mocked_response
    disk_name = "TestDisk"
    top_folders_by_size = [{ path: "folder_a", size_human: "100 MB" }]
    top_folders_by_count = [{ path: "folder_a", count: 10 }]
    
    mock_response_body = {
      'candidates' => [{
        'content' => {
          'parts' => [{
            'text' => <<~YAML
              ---
              llm_description: "A test disk summary."
              llm_storage_type: "Mock HDD"
              llm_categorization: "Tests"
              llm_tags: ["test", "mock"]
              ---
            YAML
          }]
        }
      }]
    }.to_json

    # Mock Net::HTTP request
    mock_http = mock()
    Net::HTTP.stubs(:new).returns(mock_http)
    mock_http.stubs(:use_ssl=).with(true)
    
    mock_response = mock()
    mock_response.stubs(:code).returns('200')
    mock_response.stubs(:body).returns(mock_response_body)
    
    mock_http.expects(:request).returns(mock_response)

    summary = @summarizer.summarize_disk(disk_name, top_folders_by_size, top_folders_by_count)
    
    assert_equal "A test disk summary.", summary["llm_description"]
    assert_equal "Mock HDD", summary["llm_storage_type"]
    assert_equal "Tests", summary["llm_categorization"]
    assert_includes summary["llm_tags"], "test"
  end

  def test_summarize_disk_handles_api_error
    disk_name = "TestDisk"
    top_folders_by_size = []
    top_folders_by_count = []
    
    mock_http = mock()
    Net::HTTP.stubs(:new).returns(mock_http)
    mock_http.stubs(:use_ssl=)
    
    mock_response = mock()
    mock_response.stubs(:code).returns('500')
    mock_response.stubs(:message).returns('Internal Server Error')
    mock_response.stubs(:body).returns('Error details')
    
    mock_http.expects(:request).returns(mock_response)

    summary = @summarizer.summarize_disk(disk_name, top_folders_by_size, top_folders_by_count)
    
    assert_match(/Error generating summary: Gemini API Error: 500/, summary["llm_description"])
    assert_equal "Unknown", summary["llm_storage_type"]
  end
end
