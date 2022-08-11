# frozen_string_literal: true

# require "storazzo/ric_disk/abstract_ric_disk"
# require "storazzo/ric_disk/gcs_bucket"
# require "gcs_bucket"
# require "abstract_ric_disk"

#  This class is an Abstract Class which forces its 3 inquilines to implement
#  a number of functions, namely:
#
#    def self.list_all()
#    def self.list_all_with_type()
#
#   Note this needs to work without weird overrides, like:
#
#      def self.list_all_with_type(config=nil) # BAD
#      def self.list_all_with_type()           # GOOD
#
#

module Storazzo
  module Media
    module Storazzo
      module Media
        class AbstractRicDisk
          # include Storazzo::Common
          extend Storazzo::Common

          # DefaultStatsFilename = Storazzo::RicDiskStatsFile.default_name

          # looks like there's not Abstract Class in Ruby, but also SO says he best
          # way to do this is this:

          #    attr_accessor :name, :description, :ricdisk_file, :local_mountpoint, :wr, :path, :ricdisk_file_empty, :size, :active_dirs
          attr_accessor :description

          ########################
          # Abstract methods START
          ########################
          def initialize(_local_mount)
            deb "[AbstractRicDisk.init()] Some child of AbstractRicDisk (#{self}) called me! Yummie." # disable when you dont need me anymore..
            @description ||= 'Not provided'
            # validate
          end

          def self.list_all
            raise "[AbstractRicDiskc::self.list_all] You should override this, says StackOverflow and Riccardo. Class=#{self.class}. Self=#{self}"
          end

          def self.list_all_with_type
            raise "[AbstractRicDisk::self.list_all_with_type] You should override this, says StackOverflow and Riccardo. Class=#{self.class}. Self=#{self}"
          end

          def self.super_duper_list_all_with_type
            deb 'Would be cool to be able to enumerate them all..'
            GcsBucket.list_all_with_type +
              MountPoint.list_all_with_type +
              LocalFolder.list_all_with_type
          end

          def parse(_opts = {})
            raise "[AbstractRicDiskc::parse] You should override this, says StackOverflow and Riccardo. Class=#{self.class}."
          end

          def writeable?
            raise "[AbstractRicDiskc::writeable] You should override this in class=#{self.class}, says StackOverflow and Riccardo"
          end

          def get_local_mountpoint
            # raise "[AbstractRicDiskc::get_local_mountpoint] You should override this, says StackOverflow and Riccardo"
            if local_mountpoint.nil?
              raise 'You forgot to set local_mountpoint in the constructor for your class, you cheeky little one!'
            end

            local_mountpoint
          end

          def check_implemented_correctly
            #            raise "[AbstractRicDiskc] You should override this, says StackOverflow and Riccardo"
            raise 'no @local_mountpoint' unless exists?(@local_mountpoint)
          end
          ########################
          # Abstract methods END
          ########################

          ########################
          # Automated methods now...
          ########################
          # stats_file_default_location()
          def stats_file_smart_fullpath
            # if its writeable... if not we'll think about it later.
            if writeable?
              "#{get_local_mountpoint}/#{default_stats_filename}"
            else
              # if not writeable, I will:
              # 1. create a dir based on its unique format.
              # 2. create a file of same look and feel (alternative - used a DASH)
              "TODO FIXME {get_local_folder}/#{unique_id}::#{default_stats_filename}"
              # "{get_local_folder}"/#{unique_id}/#{Storazzo::RicDiskStatsFile.default_name}"
            end
          end

          # Needs to be some unique id based on its thingy, but might change in the future:
          # Solutions:
          # {PHILOSOPHY}::{ID}
          def unique_id
            # Expand path to make it as unique as possible...
            hash = Digest::MD5.hexdigest(File.expand_path(get_local_mountpoint))
            "MD5::v1::#{hash}"
          end

          def to_s(verbose = false)
            return to_verbose_s if verbose

            readable_class = self.class.to_s.split('::').last # Storazzo::Media::LocalFolder => LocalFolder
            my_keys = instance_variables # wow!
            "S:M:#{readable_class}(path=#{path}, r/w=#{wr}, keys=#{my_keys})"
          end

          def to_verbose_s
            h = {}
            h[:class] = self.class
            h[:unique_id] = unique_id
            h[:inspect] = inspect
            h[:to_s] = to_s
            h[:local_mountpoint] = local_mountpoint
            h[:writeable] = writeable?
            h[:stats_file_smart_fullpath] = stats_file_smart_fullpath
            h
          end

          # # Todo check on instances these 3 methods exist
          def self.abstract_class_mandatory_methods
            %w[
              self.list_all
              self.list_all_with_type
              local_mountpoint
              parse
              writeable?
            ]
          end

          # Putting here since its same code for MountPoint or generic folder.
          def parse_block_storage_folder(opts = {})
            # Storazzo::RicDiskUgly.calculate_stats_files(get_local_mountpoint)
            rd = Storazzo::RicDisk.new(self)
            # Storazzo::RicDisk
            rd.compute_stats_files(opts)
            # return "42"
          end

          def self.default_stats_filename
            raise 'Unknown Storazzo::RicDiskStatsFile.default_name  1!!' if Storazzo::RicDiskStatsFile.default_name.nil?

            Storazzo::RicDiskStatsFile.default_name
          end

          # if not writeable we need to pick another from stats_file_smart_fullpath()
          def stats_filename_default_fullpath
            # REDUNDANT, should use stats_file_smart_fullpath instead except on the writeable? part since it would go recursive otherwise.
            my_stats_filename = default_stats_filename
            # raise "Unknown Storazzo::RicDiskStatsFile.default_name 2 !!" if Storazzo::RicDiskStatsFile.default_name.nil?
            "#{local_mountpoint}/#{my_stats_filename}"
          end

          def validate(opts = {})
            opt_verbose = opts.fetch :verbose, false
            pverbose opt_verbose,
                     "validate(): [BROKEN] We're trying to see if your object is valid, across 3 possible sub-classes."
            # 1. check for
            raise 'Unknown local mount ' unless local_mount.is_a?(String)

            # 2. check thaty writeable? is true or false
            my_writeable = wr
            raise 'Writeable is not boolean' unless my_writeable.is_a?(TrueClass) || my_writeable.is_a?(FalseClass)
          end

          # TODO: use a proper Factory pattern.
          def self.DirFactory(path)
            raise "I need a path/directory string: #{path}" unless path.is_a?(String)

            deb 'TODO: if coincides with MountPoint, instance THAT'
            # if path in Storazzo::Media::MountPoint.list_all_mount_points
            # then return ...
            if path =~ %r{^gs://}
              deb 'Smells like GCS'
              return GcsBucket.new(path)
            end
            deb 'Smells like LocalFolder :)'
            LocalFolder.new(path)
          end
        end
      end
    end
  end
end
