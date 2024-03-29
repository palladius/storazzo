# frozen_string_literal: true

require 'English'

module Storazzo
  module Media
    #  class Storazzo::Media::AbstractRicDisk
    module Storazzo
      module Media
        class GcsBucket < Storazzo::Media::AbstractRicDisk
          extend Storazzo::Common

          attr_accessor :project_id

          def initialize(local_mount, project_id = nil)
            deb '[Storazzo::Media::GcsBucket] initialize'

            @local_mountpoint = File.expand_path(local_mount)
            @description = "MountPoint in '#{local_mount}' pointing at TODO with mount options = TODO"
            project_id ||= _autodetect_project_id
            @project_id = project_id
            raise 'Sorry local mount doesnt exist!' unless File.exist?(@local_mountpoint)

            @wr = writeable? # File.writable?(stats_filename_default_fullpath) # .writeable? stats_file_smart_fullpath
            begin
              super(local_mount)
            rescue StandardError
              "SUPER_ERROR(#{local_mount}): #{$ERROR_INFO}"
            end
          end

          def _autodetect_project_id
            'todo-my-project-id-123' # TODO: fix
          end

          # (config = nil)
          def self.list_all
            # get lisrts from Config singletone
            # puts " self.list_all: loading config "
            config ||= Storazzo::RicDiskConfig.instance # # ).get_config

            config.load # in case I need to load it for the first time
            # puts config['Config']['AdditionalMountDirs']
            # puts "TODO see config: #{config}"
            # [42, 43]
            # deb config.get_local_folders
            # TODO
            pverbose true,
                     "TODO(ricc): also add gsutil ls. For that please use the new 'list_all_with_type' (Id refactor it but Im afraid of leaving bad code dangling so before a proper refactor lets implement both side by side"
            config.get_bucket_paths
          end

          # (config = nil)
          def self.list_all_with_type
            deb 'GCS::list_all_with_type() -- pull config'
            config ||= Storazzo::RicDiskConfig.instance
            config.load # in case I need to load it for the first time
            # puts "GCS::list_all_with_type() -- TODO(ricc): also add gsutil ls"
            # getFromConfig
            deb "I'm now returning a 'complex' array to tell the caller what kind of element they're getting, eg: GCS from Config Yaml, vs GCS from gsutil ls "
            list_from_config_with_type = config.get_bucket_paths.map do |path|
              [:config_gcs_bucket, path]
            end
            ret_list = list_from_config_with_type
            if config.gcs_enabled? # should be if GCS enabled :) project_id
              # so I concatenate Apples with Bananas with names
              # ret_list += list_available_buckets(config.project_id).map { |path|
              ret_list += list_available_buckets.map do |path|
                [:gsutil_ls_gcs_bucket, path]
              end
            else
              deb 'list_all_with_type(): empty project id. Skipping'
            end

            ret_list
          end

          def self.list_available_buckets(_opts = {})
            # project_id = opts.fetch :project_id, nil
            # list_of_buckets = `gsutil ls --project '#{project_id}'`.chomp.split("\n")
            list_of_buckets = `gsutil ls`.chomp.split("\n")
            deb "list_of_buckets: #{list_of_buckets}"
            list_of_buckets
          end
        end
      end
    end
  end
end
