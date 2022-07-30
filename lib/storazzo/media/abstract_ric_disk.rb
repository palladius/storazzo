module Storazzo::Media
    class Storazzo::Media::AbstractRicDisk
        #include Storazzo::Common
        extend Storazzo::Common

        #DefaultStatsFilename = Storazzo::RicDiskStatsFile.default_name

            # looks like there's not Abstract Class in Ruby, but also SO says he best
            # way to do this is this: 
            
            #    attr_accessor :name, :description, :ricdisk_file, :local_mountpoint, :wr, :path, :ricdisk_file_empty, :size, :active_dirs
            attr_accessor :description
            ########################
            # Abstract methods START
            ########################
            def initialize(local_mount)
                deb "[AbstractRicDisk.init()] Some child of AbstractRicDisk (#{self}) called me! Yummie." # disable when you dont need me anymore..
                @description ||= "Not provided"
                #validate
            end
            def self.list_all
                raise "[AbstractRicDiskc::self.list_all] You should override this, says StackOverflow and Riccardo"
            end
            def self.list_all_with_type
                raise "[AbstractRicDiskc::self.list_all_with_type] You should override this, says StackOverflow and Riccardo"
            end
            def self.super_duper_list_all_with_type
                deb "Would be cool to be able to enumerate them all.."
                GcsBucket.list_all_with_type + 
                    MountPoint.list_all_with_type + 
                        LocalFolder.list_all_with_type 
            end
            def parse(opts={})
                raise "[AbstractRicDiskc::parse] You should override this, says StackOverflow and Riccardo"
            end
            def writeable?
                raise "[AbstractRicDiskc::writeable] You should override this in #{self.class}, says StackOverflow and Riccardo"
            end
            def get_local_mountpoint
                #raise "[AbstractRicDiskc::get_local_mountpoint] You should override this, says StackOverflow and Riccardo"
                raise "You forgot to set local_mountpoint in the constructor for your class, you cheeky little one!" if local_mountpoint.nil? 
                local_mountpoint
            end
            def check_implemented_correctly
    #            raise "[AbstractRicDiskc] You should override this, says StackOverflow and Riccardo"
                raise "no @local_mountpoint" unless exists?(@local_mountpoint)
            end
            ########################
            # Abstract methods END
            ########################



            ########################
            # Automated methods now...
            ########################
            def stats_file_smart_fullpath # stats_file_default_location()
                # if its writeable... if not we'll think about it later.
                if writeable?
                     return "#{get_local_mountpoint}/#{self.default_stats_filename}"
                else
                    # if not writeable, I will:
                    # 1. create a dir based on its unique format.
                    # 2. create a file of same look and feel (alternative - used a DASH)
                    return "TODO FIXME {get_local_folder}/#{unique_id}::#{self.default_stats_filename}"
                    #"{get_local_folder}"/#{unique_id}/#{Storazzo::RicDiskStatsFile.default_name}"
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

            def to_s(verbose=false)
                return to_verbose_s() if verbose
                readable_class = self.class.to_s.split('::').last # Storazzo::Media::LocalFolder => LocalFolder
                my_keys = self.instance_variables # wow!
                "S:M:#{readable_class}(path=#{path}, r/w=#{wr}, keys=#{my_keys})"
            end

            def to_verbose_s
                h = {}
                h[:class] = self.class 
                h[:unique_id] = self.unique_id
                h[:inspect] = self.inspect
                h[:to_s] = self.to_s
                h[:local_mountpoint] = local_mountpoint
                h[:writeable] = self.writeable?
                h[:stats_file_smart_fullpath] = stats_file_smart_fullpath
                return h
            end

            # # Todo check on instances these 3 methods exist
            def self.abstract_class_mandatory_methods
                %W{
                    self.list_all
                    self.list_all_with_type
                    local_mountpoint
                    parse
                    writeable? 
                }
            end

            # Putting here since its same code for MountPoint or generic folder.
            def parse_block_storage_folder(opts={})
                #Storazzo::RicDiskUgly.calculate_stats_files(get_local_mountpoint)
                Storazzo::RicDisk.calculate_stats_files(get_local_mountpoint, opts)
                #return "42"
            end

            def self.default_stats_filename
                raise "Unknown Storazzo::RicDiskStatsFile.default_name  1!!" if Storazzo::RicDiskStatsFile.default_name.nil?
                Storazzo::RicDiskStatsFile.default_name
            end

            def stats_filename_default_fullpath # if not writeable we need to pick another from stats_file_smart_fullpath()
                # REDUNDANT, should use stats_file_smart_fullpath instead except on the writeable? part since it would go recursive otherwise.
                my_stats_filename = self.default_stats_filename 
                #raise "Unknown Storazzo::RicDiskStatsFile.default_name 2 !!" if Storazzo::RicDiskStatsFile.default_name.nil?
                "#{local_mountpoint}/#{my_stats_filename}"
            end

            def validate(opts={})
                verbose = opts.fetch(:verbose, true)
                puts "[VERBOSE] validate(): We're trying to see if your object is valid, across 3 possible sub-classes." if verbose
                #1. check for 
                raise "Unknown local mount " unless local_mount.is_a?(String)
                #2. check thaty writeable? is true or false
                my_writeable = wr
                raise "Writeable is not boolean" unless (my_writeable.is_a? TrueClass or my_writeable.is_a? FalseClass )
            end

            # TODO use a proper Factory pattern.
            def self.DirFactory(path)
                raise "I need a path/directory string: #{path}" unless path.is_a?(String)

                deb "TODO: if coincides with MountPoint, instance THAT"
                # if path in Storazzo::Media::MountPoint.list_all_mount_points
                # then return ...
                if path =~ /^gs:\/\//
                    deb "Smells like GCS"
                    return GcsBucket.new(path)
                end
                deb "Smells like LocalFolder :)"
                return LocalFolder.new(path)
            end
    end
end
