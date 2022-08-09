require "minitest/autorun"
require "storazzo"

# require 'pry' # must install the gem... but you ALWAYS want pry installed anyways

class MediaMountPointTest < Minitest::Test
  def test_test_in_subfolder
    # raise "Does this even work?!?"
    puts "Looks like this only works if you run this: ruby -I test test/media/test_media_mount_point.rb"
  end

  def test_mount_point_creation
    # x = Storazzo::Media::MountPoint.new
    # assert class inherits from ...
    skip "TODO Code is still missing but TODO implement that this class inherits from **ther class"
    # assert(
    #     false,
    #     "TODO Code is still missing but TODO implement that this class inherits from **ther class"
    # )
  end

  def test_what_skip_means
    skip 'Check for blah blah blah. Found example online. Please Riccardo fix. This is just an example of how to SKIP a test :)'
  end

end
