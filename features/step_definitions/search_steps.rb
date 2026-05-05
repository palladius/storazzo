# frozen_string_literal: true

Given('a local SQLite index with the following entries:') do |table|
  require 'storazzo/search_engine'
  # Aruba uses a temporary directory for each scenario
  db_path = File.expand_path("storazzo_test.db", Aruba.config.working_directory)
  ENV['STORAZZO_DB_PATH'] = db_path
  
  engine = Storazzo::SearchEngine.new(db_path)
  
  table.hashes.each do |row|
    disk_id = engine.find_or_create_disk(row['disk'])
    # Ingesting a manual entry into the files table
    # md5, size, path, disk_id, file_mtime, content_type, ingested_at
    engine.instance_variable_get(:@db).execute <<-SQL, [row['md5'], 100, row['path'], disk_id, Time.now.iso8601, 'text/plain', Time.now.iso8601]
      INSERT INTO files (md5, size, path, disk_id, file_mtime, content_type, ingested_at) 
      VALUES (?, ?, ?, ?, ?, ?, ?)
    SQL
  end
end
