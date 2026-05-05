# frozen_string_literal: true

require 'sqlite3'
require 'fileutils'
require 'google/cloud/storage'
require 'storazzo/common'

module Storazzo
  class SearchEngine
    include Storazzo::Common
    DEFAULT_DB_PATH = File.expand_path("~/.storazzo_index.db")

    attr_accessor :db_path

    def initialize(db_path = nil)
      @db_path = db_path || ENV['STORAZZO_DB_PATH'] || DEFAULT_DB_PATH
      @db = SQLite3::Database.new(@db_path)
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
      client = Storazzo::GCS::Client.new
      config = Storazzo::RicDiskConfig.instance
      config.load
      
      buckets = config.get_bucket_paths
      puts "Syncing metadata from #{buckets.size} buckets..."
      
      buckets.each do |bucket_url|
        bucket_name = bucket_url.gsub('gs://', '').split('/').first
        # For now, we search in the standard 'backup/ricdisk-magic/' path
        prefix = "backup/ricdisk-magic/"
        
        begin
          bucket = client.storage.bucket(bucket_name)
          next unless bucket
          
          files = bucket.files(prefix: prefix)
          rds_files = files.select { |f| f.name.end_with?('.rds') }
          
          puts "--- Bucket: gs://#{bucket_name} (#{rds_files.size} catalogs found) ---"
          
          rds_files.each do |remote_file|
            # 1. Download to local tmp
            local_tmp_path = File.join(Dir.tmpdir, File.basename(remote_file.name))
            puts "Downloading #{remote_file.name}..."
            remote_file.download(local_tmp_path)
            
            # 2. Ingest into SQLite
            disk_name = File.basename(remote_file.name, '.rds').gsub('-ricdisk_stats_v11', '')
            ingest_stats_file(local_tmp_path, disk_name)
            
            # 3. Cleanup
            FileUtils.rm(local_tmp_path)
          end
        rescue => e
          warn "Error syncing from gs://#{bucket_name}: #{e.message}"
        end
      end
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
