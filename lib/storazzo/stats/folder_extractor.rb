# frozen_string_literal: true

require 'storazzo/common'

module Storazzo
  module Stats
    class FolderExtractor
      include Storazzo::Common

      def initialize(file_path)
        @file_path = file_path
        raise "RDS file not found: #{file_path}" unless File.exist?(file_path)
        @stats = {}
        parse_file
      end

      def top_folders_by_size(limit = 5)
        @stats.values
              .sort_by { |f| -f[:size] }
              .take(limit)
      end

      def top_folders_by_count(limit = 5)
        @stats.values
              .sort_by { |f| -f[:count] }
              .take(limit)
      end

      private

      def parse_file
        File.readlines(@file_path).each do |line|
          next if line.start_with?('#') || line.strip.empty?
          
          # Format: [file_v1.2] md5 mode type datetime size [content_type] filename
          parts = line.split(' ')
          
          # Locating the `[content_type]` bracket
          content_type_idx = parts.find_index { |p| p.start_with?('[') && p.end_with?(']') && p != parts.first }
          next unless content_type_idx
          
          size = parts[content_type_idx - 1].to_i
          filename = parts[(content_type_idx + 1)..-1].join(' ')
          
          dir = File.dirname(filename).gsub(/^\.\//, '')
          update_folder_stats(dir, size)
        end
      end

      def update_folder_stats(dir, size)
        @stats[dir] ||= { path: dir, size: 0, count: 0 }
        @stats[dir][:size] += size
        @stats[dir][:count] += 1
      end
    end
  end
end
