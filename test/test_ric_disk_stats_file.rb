require "storazzo/ric_disk_statsfile"

class RicDiskStatsFileTest < Minitest::Test
  def test_version
    version = Storazzo::RicDiskStatsFile.version
    assert(version.is_a?(String),
           "version should produce a bloody string :P")
  end

  def test_default_name
    dname = Storazzo::RicDiskStatsFile.default_name
    assert(dname.is_a?(String),
           "DefaultName should produce a bloody string :P")
  end
end
# module Storazzo
#     class Storazzo::RicDiskStatsFile
#         # Please keep these two in sync, until you fix them and DRY the behaviour.
#         #@@default_name
#         DefaultName = "ricdisk_stats_v11.rds" # => RicDiskStatsFile
#         Version      = "1.1" # @@version

#         # AttrAccessor for class - thanks StackOverflow from Android since Im in roaming :)
#         class << self
#             attr_accessor :default_name, :version
#         end

#         def self.default_name
#              DefaultName
#         end
#         def self.version
#             Version
#        end
#     end
# end
