module Storazzo::Media

    class Storazzo::Media::AbstractRicDisk

            # looks like there's not Abstract Class in Ruby, but also SO says he best
            # way to do this is this: 
            
            #    attr_accessor :name, :description, :ricdisk_file, :local_mountpoint, :wr, :path, :ricdisk_file_empty, :size, :active_dirs

            ########################
            # Abstract methods START
            ########################
            def initialize
                puts "[DEB] [AbstractRicDisk.init()] Some child of AbstractRicDisk (#{self}) called me! Yummie." # disable when you dont need me anymore..
            end
            def self.list_all
                raise "[AbstractRicDiskc::self.list_all] You should override this, says StackOverflow and Riccardo"
            end
            def parse
                raise "[AbstractRicDiskc::parse] You should override this, says StackOverflow and Riccardo"
            end
            def writeable?
                raise "[AbstractRicDiskc::writeable] You should override this, says StackOverflow and Riccardo"
            end
            def get_local_mountpoint
                raise "[AbstractRicDiskc::get_local_mountpoint] You should override this, says StackOverflow and Riccardo"
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
            def stats_file_default_location()
                # if its writeable... if not we'll think about it later.
                 "#{get_local_mountpoint}/#{Storazzo::RicDiskStatsFile.default_name}"                     
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

    end

    #puts "DEB lib/storazzo/media/abstract_ric_disk Media::ARD inside module"

end


#puts "DEB lib/storazzo/media/abstract_ric_disk Media::ARD outside module"
