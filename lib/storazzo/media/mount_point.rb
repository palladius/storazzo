# TODO
module Storazzo::Media
  class Storazzo::Media::MountPoint < Storazzo::Media::AbstractRicDisk
    # puts "[REMOVEME] Storazzo::Media::MountPoint being read. REMOVEME when you see this :)"

    def self.list_local_mount_points()
      deb "Maybe its abuot time you refactor that method here :)"
      RicDisk.interesting_mount_points()
    end
  end
end

#         def writeable?
# File.writable?(@local_mountpoint)
# end
