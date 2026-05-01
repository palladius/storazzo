# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'dotenv'
require 'yaml'
require 'storazzo/common'

module Storazzo
  module LLM
    class GeminiSummarizer
      include Storazzo::Common

      # Using the discovered model name
      MODEL_NAME = 'gemini-2.5-flash'
      API_URL = "https://generativelanguage.googleapis.com/v1/models/#{MODEL_NAME}:generateContent"

      def initialize(api_key = nil)
        Dotenv.load
        @api_key = api_key || ENV['GEMINI_API_KEY']
        raise "GEMINI_API_KEY not found in environment or .env file" unless @api_key
        deb "GeminiSummarizer initialized using direct REST API"
      end

      def summarize_disk(disk_name, top_folders_by_size, top_folders_by_count, content_preview = "")
        if ENV['STORAZZO_MOCK_LLM'] == 'true'
          return {
            "llm_description" => "Mocked description for #{disk_name}",
            "llm_storage_type" => "Mock Storage",
            "llm_categorization" => "Mock Category",
            "llm_tags" => ["mock", "test"]
          }
        end

        prompt = <<~PROMPT
          You are an expert digital archivist. I am providing you with statistics from a disk scan (Storazzo).
          Please provide a concise YAML summary of this disk's contents.

          Disk Name: #{disk_name}
          
          Top 5 Folders by Size:
          #{top_folders_by_size.map { |f| "- #{f[:path]} (#{f[:size_human]})" }.join("\n")}

          Top 5 Folders by File Count:
          #{top_folders_by_count.map { |f| "- #{f[:path]} (#{f[:count]} files)" }.join("\n")}

          File Preview (first few files):
          #{content_preview}

          Expected YAML Output format:
          ---
          llm_description: "A 1-2 sentence description of the disk."
          llm_storage_type: "The likely physical storage type (e.g., Backup HDD, Media Drive, Source Code Archive)."
          llm_categorization: "Main categories (e.g., Photos, Videos, Documents)."
          llm_tags: ["tag1", "tag2"]
          ---
          Only return the YAML block.
        PROMPT

        uri = URI.parse("#{API_URL}?key=#{@api_key}")
        header = { 'Content-Type': 'application/json' }
        body = {
          contents: [{
            parts: [{ text: prompt }]
          }]
        }

        begin
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          request = Net::HTTP::Post.new(uri.request_uri, header)
          request.body = body.to_json
          
          response = http.request(request)
          
          if response.code == '200'
            result = JSON.parse(response.body)
            yaml_text = result['candidates'][0]['content']['parts'][0]['text']
            # Extract YAML between --- if present, or just clean it up
            yaml_text = yaml_text.gsub(/```yaml|```/, '').strip
            YAML.safe_load(yaml_text)
          else
            raise "Gemini API Error: #{response.code} #{response.message} - #{response.body}"
          end
        rescue StandardError => e
          err "Failed to generate Gemini summary: #{e.message}"
          {
            "llm_description" => "Error generating summary: #{e.message}",
            "llm_storage_type" => "Unknown",
            "llm_categorization" => "Unknown",
            "llm_tags" => []
          }
        end
      end
    end
  end
end
