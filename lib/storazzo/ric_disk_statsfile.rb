# This class wraps the RDS file: we're going to write this RDS file
# directly in the disk: /mount/
module Storazzo
    class Storazzo::RicDiskStatsFile
        # Please keep these two in sync, until you fix them and DRY the behaviour.
        @@default_name = "ricdisk_stats_v11.rds" # => RicDiskStatsFile
        @@version      = "1.1"

        # AttrAccessor for class - thanks StackOverflow from Android since Im in roaming :)
        class << self 
            attr_accessor :default_name, :version
        end
        # def self.default_name
        #     @@default_name
        # end
        
    end
end 