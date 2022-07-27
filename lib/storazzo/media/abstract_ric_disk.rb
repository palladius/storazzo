module Storazzo::Media
    class Storazzo::Media::AbstractRicDisk

        #@@default_stats_filename = Storazzo::RicDiskStatsFile.default_name

            # looks like there's not Abstract Class in Ruby, but also SO says he best
            # way to do this is this: 
            
            #    attr_accessor :name, :description, :ricdisk_file, :local_mountpoint, :wr, :path, :ricdisk_file_empty, :size, :active_dirs

            ########################
            # Abstract methods START
            ########################
            def initialize(local_mount)
                puts "[DEB] [AbstractRicDisk.init()] Some child of AbstractRicDisk (#{self}) called me! Yummie." # disable when you dont need me anymore..
                validate
            end
            def self.list_all
                raise "[AbstractRicDiskc::self.list_all] You should override this, says StackOverflow and Riccardo"
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
                    return "{get_local_folder}/#{unique_id}::#{self.default_stats_filename}"
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

            # # Todo check on instances these 3 methods exist
            def self.abstract_class_mandatory_methods
                %W{
                    self.list_all
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
            # def default_stats_filename
            #     self.default_stats_filename
            # end

            def stats_filename_default_fullpath # if not writeable we need to pick another from stats_file_smart_fullpath()
                # REDUNDANT, should use stats_file_smart_fullpath instead except on the writeable? part since it would go recursive otherwise.
                my_stats_filename = self.default_stats_filename 
                #raise "Unknown Storazzo::RicDiskStatsFile.default_name 2 !!" if Storazzo::RicDiskStatsFile.default_name.nil?
                "#{local_mountpoint}/#{my_stats_filename}"
            end

            def validate
                puts "DEB We're trying to see if your object is valid, across 3 possible sub-classes."
                #1. check for 
                raise "Unknown local mount " unless local_mount.is_a?(String)
                #2. check thaty writeable? is true or false
                my_writeable = wr
                raise "Writeable is not boolean" unless (my_writeable.is_a? TrueClass or my_writeable.is_a? FalseClass )
            end
    end
    #puts "DEB lib/storazzo/media/abstract_ric_disk Media::ARD inside module"
end
#puts "DEB lib/storazzo/media/abstract_ric_disk Media::ARD outside module"
