# frozen_string_literal: true

# require "storazzo/ric_disk/abstract_ric_disk"
# require "abstract_ric_disk"

require 'English'
module Storazzo
  module Media
    module Storazzo
      module Media
        class LocalFolder < Storazzo::Media::AbstractRicDisk
          # extend Storazzo::Common
          include Storazzo::Common

          attr_accessor :local_mountpoint, :wr

          def initialize(local_mount)
            deb '[Storazzo::Media::LocalFolder] initialize'

            @local_mountpoint = File.expand_path(local_mount)
            @description = "Local Folder originally in '#{local_mount}'"
            raise 'Sorry local mount doesnt exist!' unless File.exist?(@local_mountpoint)

            @wr = writeable? # File.writable?(stats_filename_default_fullpath) # .writeable? stats_file_smart_fullpath
            # super.initialize(local_mount) rescue "SUPER_ERROR: #{$!}"
            begin
              super(local_mount)
            rescue StandardError
              "SUPER_ERROR(#{local_mount}): #{$ERROR_INFO}"
            end
          end

          # WRONG: config = nil
          def self.list_all
            # get lists from Config singleton
            config = Storazzo::RicDiskConfig.instance # # ).get_config
            config.load
            config.get_local_folders
          end

          def parse(opts = {})
            puts "LF.parse(#{opts}): TODO Sbrodola inside the dir: #{local_mountpoint}"
            parse_block_storage_folder
          end

          def path
            @local_mountpoint
          end

          def writeable?
            File.writable?(@local_mountpoint)
          end

          def default_stats_filename
            # '42'
            Storazzo::RicDiskStatsFile.default_name
          end
        end
      end
    end
  end
end
