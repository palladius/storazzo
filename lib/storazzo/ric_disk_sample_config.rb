require 'singleton'
require 'yaml'

require_relative "./common"
require_relative "./ric_disk_config"

=begin
    This is a singleton class. You call me this way..
    You call me with:

    Storazzo::RicDiskSampleConfig.instance()

=end

module Storazzo
  class Storazzo::RicDiskSampleConfig < Storazzo::RicDiskConfig
    # include Storazzo::Common

    public

    def load # _sample_version
      deb("[RicDiskSampleConfig] Wheew 1! We're NOT destroying the world here. We're actually instancing a second Singleton which is a child of the mother, and this time doing things nicely and Rubily.")
      super(DefaultGemLocationForTests, :verbose => false)
    end

    def load_sample_version
      deb white("[RicDiskSampleConfig] Wheew 2! We're NOT destroying the world here. We're actually instancing a second Singleton which is a child of the mother, and this time doing things nicely and Rubily.")
      super(DefaultGemLocationForTests, :verbose => false)
    end
  end
end # module Storazzo
