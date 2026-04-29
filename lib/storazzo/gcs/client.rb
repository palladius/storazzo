# frozen_string_literal: true

require 'google/cloud/storage'
require 'storazzo/common'

module Storazzo
  module GCS
    class Client
      include Storazzo::Common

      attr_reader :storage, :project_id

      def initialize(project_id = nil)
        @project_id = project_id || autodetect_project_id
        @storage = Google::Cloud::Storage.new(project_id: @project_id)
        deb "GCS Client initialized for project: #{@project_id}"
      end

      def autodetect_project_id
        # Priority 1: Environment Variable
        return ENV['GOOGLE_CLOUD_PROJECT'] if ENV['GOOGLE_CLOUD_PROJECT']
        
        # Priority 2: Config file
        config = Storazzo::RicDiskConfig.instance
        config.load
        return config.project_id if config.project_id && config.project_id != 'YOUR-PROJECT-ID'

        # Priority 3: GCloud CLI default
        begin
          `gcloud config get-value project 2>/dev/null`.strip
        rescue StandardError
          nil
        end
      end

      def bucket_exists?(bucket_name)
        bucket_name = bucket_name.gsub('gs://', '').split('/').first
        !@storage.bucket(bucket_name).nil?
      rescue StandardError => e
        warn "Error checking bucket #{bucket_name}: #{e.message}"
        false
      end

      def list_buckets
        @storage.buckets.map(&:name)
      end

      def upload_file(local_path, bucket_name, remote_path)
        bucket_name = bucket_name.gsub('gs://', '').split('/').first
        bucket = @storage.bucket(bucket_name)
        raise "Bucket #{bucket_name} not found!" unless bucket

        deb "Uploading #{local_path} to gs://#{bucket_name}/#{remote_path}..."
        bucket.create_file(local_path, remote_path)
      end

      def download_file(bucket_name, remote_path, local_path)
        bucket_name = bucket_name.gsub('gs://', '').split('/').first
        bucket = @storage.bucket(bucket_name)
        raise "Bucket #{bucket_name} not found!" unless bucket

        file = bucket.file(remote_path)
        raise "Remote file #{remote_path} not found in bucket #{bucket_name}!" unless file

        deb "Downloading gs://#{bucket_name}/#{remote_path} to #{local_path}..."
        file.download(local_path)
      end
    end
  end
end
