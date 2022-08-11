# frozen_string_literal: true

# TODO
module Storazzo
  module Media
    module Storazzo
      module Media
        class MountPoint < Storazzo::Media::AbstractRicDisk
          # puts "[REMOVEME] Storazzo::Media::MountPoint being read. REMOVEME when you see this :)"

          def self.list_local_mount_points
            deb 'Maybe its abuot time you refactor that method here :)'
            RicDisk.interesting_mount_points
          end

          def self.list_all
            RicDisk.interesting_mount_points
          end

          def self.list_all_with_type
            list_all.map { |x| [:mount_point_todo_less_generic, x] }
          end
        end
      end
    end
  end
end

#         def writeable?
# File.writable?(@local_mountpoint)
# end
