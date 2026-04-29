# frozen_string_literal: true

require 'sqlite3'
require 'fileutils'
require 'google/cloud/storage'
require 'storazzo/common'

module Storazzo
  class SearchEngine
    include Storazzo::Common
    DB_PATH = File.expand_path("~/.storazzo_index.db")

    def initialize
      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true
      create_tables
    end

    def create_tables
      @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS disks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          slug TEXT UNIQUE,
          type TEXT,
          uuid TEXT,
          llm_description TEXT,
          llm_storage_type TEXT,
          last_scanned_at DATETIME
        );
      SQL

      @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS files (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          md5 VARCHAR(32),
          size INTEGER,
          path TEXT,
          disk_id INTEGER,
          file_mtime DATETIME,
          content_type TEXT,
          ingested_at DATETIME,
          FOREIGN KEY(disk_id) REFERENCES disks(id),
          UNIQUE(disk_id, path)
        );
      SQL
    end

    def sync_from_gcs
      puts "Syncing metadata from GCS... (Stub)"
      # Here we would use Google::Cloud::Storage to download `.rds` files
      # from the designated GCS metadata bucket and then call `ingest_stats_file`.
    end

    def query(string)
      @db.execute <<-SQL, ["%#{string}%", "%#{string}%", "%#{string}%"]
        SELECT f.*, d.name as disk_name, d.slug as disk_slug 
        FROM files f 
        JOIN disks d ON f.disk_id = d.id
        WHERE f.path LIKE ? OR d.name LIKE ? OR d.slug LIKE ?
      SQL
    end
    
    def find_or_create_disk(disk_name, opts = {})
      slug = slugify(disk_name)
      type = opts[:type] || 'local'
      uuid = opts[:uuid]
      llm_desc = opts[:llm_description]
      llm_storage = opts[:llm_storage_type]
      
      @db.execute <<-SQL, [disk_name, slug, type, uuid, llm_desc, llm_storage]
        INSERT OR IGNORE INTO disks (name, slug, type, uuid, llm_description, llm_storage_type) 
        VALUES (?, ?, ?, ?, ?, ?)
      SQL
      
      # Update existing record if new info is provided
      if uuid || llm_desc || llm_storage
        @db.execute <<-SQL, [uuid, llm_desc, llm_storage, slug]
          UPDATE disks SET uuid = COALESCE(?, uuid), 
                           llm_description = COALESCE(?, llm_description),
                           llm_storage_type = COALESCE(?, llm_storage_type)
          WHERE slug = ?
        SQL
      end

      @db.get_first_value("SELECT id FROM disks WHERE slug = ?", [slug])
    end

    def ingest_stats_file(file_path, disk_name)
      disk_id = find_or_create_disk(disk_name)
      ingested_at = Time.now.iso8601
      
      puts "Ingesting #{file_path} (disk_id: #{disk_id})..."
      
      @db.transaction do
        File.readlines(file_path).each do |line|
          next if line.start_with?('#') || line.strip.empty?
          
          # Example format:
          # [file_v1.2] md5 mode type datetime size [content_type] filename
          parts = line.split(' ')
          
          # Locating the `[content_type]` bracket
          content_type_idx = parts.find_index { |p| p.start_with?('[') && p.end_with?(']') && p != parts.first }
          next unless content_type_idx
          
          md5 = parts[1]
          file_mtime = parts[4] # Standardized creation/mod time
          size = parts[content_type_idx - 1].to_i
          content_type = parts[content_type_idx].gsub(/[\[\]]/, '')
          path = parts[(content_type_idx + 1)..-1].join(' ')
          
          begin
            @db.execute <<-SQL, [md5, size, path, disk_id, file_mtime, content_type, ingested_at]
              INSERT OR REPLACE INTO files (md5, size, path, disk_id, file_mtime, content_type, ingested_at) 
              VALUES (?, ?, ?, ?, ?, ?, ?)
            SQL
          rescue SQLite3::Exception => e
            puts "Error inserting #{path}: #{e.message}"
          end
        end
      end
      
      @db.execute("UPDATE disks SET last_scanned_at = ? WHERE id = ?", [ingested_at, disk_id])
    end
  end
end
