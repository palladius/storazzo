# frozen_string_literal: true

require 'aruba/cucumber'

Aruba.configure do |config|
  config.exit_timeout = 60 # Gemini can be slow
end

Before do
  # Add bin to path
  bin_dir = File.expand_path('../../bin', __dir__)
  ENV['PATH'] = "#{bin_dir}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
  ENV['STORAZZO_MOCK_LLM'] = 'true'
  ENV['GEMINI_API_KEY'] = 'mock-key'
end
