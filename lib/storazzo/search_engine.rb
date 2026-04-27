# frozen_string_literal: true

require 'sqlite3'
require 'fileutils'
require 'google/cloud/storage'

module Storazzo
  class SearchEngine
    DB_PATH = File.expand_path("~/.storazzo_index.db")

    def initialize
      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true
      create_tables
    end

    def create_tables
      @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS files (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          md5 VARCHAR(32),
          size INTEGER,
          path TEXT,
          disk TEXT,
          UNIQUE(disk, path)
        );
      SQL
    end

    def sync_from_gcs
      puts "Syncing metadata from GCS... (Stub)"
      # Here we would use Google::Cloud::Storage to download `.rds` files
      # from the designated GCS metadata bucket and then call `ingest_stats_file`.
    end

    def query(string)
      @db.execute("SELECT * FROM files WHERE path LIKE ? OR disk LIKE ?", ["%#{string}%", "%#{string}%"])
    end
    
    def ingest_stats_file(file_path, disk_name)
      File.readlines(file_path).each do |line|
        next if line.start_with?('#') || line.strip.empty?
        
        # Example format:
        # [file_v1.2] md5 mode type datetime size [content_type] filename
        parts = line.split(' ')
        
        # very basic extraction trying to find the `[content_type]` bracket to locate the filename
        content_type_idx = parts.find_index { |p| p.start_with?('[') && p.end_with?(']') && p != parts.first }
        next unless content_type_idx
        
        md5 = parts[1]
        size = parts[content_type_idx - 1].to_i
        path = parts[(content_type_idx + 1)..-1].join(' ')
        
        begin
          @db.execute("INSERT OR REPLACE INTO files (md5, size, path, disk) VALUES (?, ?, ?, ?)", [md5, size, path, disk_name])
        rescue SQLite3::Exception => e
          puts "Error inserting #{path}: #{e.message}"
        end
      end
    end
  end
end
