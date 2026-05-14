# frozen_string_literal: true

require 'digest/md5'
require 'socket'
require 'date'
require 'mime/types'

module Storazzo
  module Stats
    class FileService
      include Storazzo::Common
      
      ENTITY_TYPE = 'file_v1.2'

      def self.compute_stats(file_path)
        stats = File.stat(file_path)
        
        md5 = '______________NONE______________'
        if stats.file?
          # Optimized for large files by reading in chunks internally
          md5 = Digest::MD5.file(file_path).hexdigest
        end

        file_type = stats.ftype[0]
        file_type = 's' if File.symlink?(file_path)
        
        # Format mode as 6-digit octal (e.g., 100644)
        mode = sprintf('%06o', stats.mode)
        
        # Performance Optimization: Use native Ruby mime-types first
        content_type = MIME::Types.type_for(file_path).first&.content_type
        
        # System Fallback: if native detection fails, use the `file` command
        if content_type.nil?
          content_type = `file --mime-type -b '#{file_path}' 2>/dev/null`.chomp
        end
        
        content_type = "application/octet-stream" if content_type.nil? || content_type.empty?

        {
          entity_type: ENTITY_TYPE,
          md5: md5,
          mode: mode,
          file_type: file_type,
          mtime: stats.mtime.iso8601,
          size: stats.size,
          content_type: content_type,
          path: file_path
        }
      rescue Errno::EISDIR
        # Should not happen with stats.file? check but for safety
        nil
      rescue StandardError => e
        { error: e.message, path: file_path }
      end

      def self.format_rds_line(data)
        return "# Error processing #{data[:path]}: #{data[:error]}" if data[:error]
        
        # Format: [entity_type] md5 mode file_type mtime size [content_type] path
        sprintf("[%s] %s %s %s %s %10d [%s] %s",
          data[:entity_type],
          data[:md5],
          data[:mode],
          data[:file_type],
          data[:mtime],
          data[:size],
          data[:content_type],
          data[:path]
        )
      end

      def self.calculate_and_format(file_path)
        data = compute_stats(file_path)
        return nil unless data
        format_rds_line(data)
      end
    end
  end
end
