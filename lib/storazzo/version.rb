# copied from https://github.com/rails/strong_parameters/edit/master/lib/strong_parameters/version.rb
# I;'m copying the DHH philosophy here.
module Storazzo
    DHH_VERSION = "0.2.3_TODOFileRead" # TODO file.read ../../VERSION . chomp
    RICC_VERSION = File.read("../VERSION").chomp

    public
    def self.version 
        RICC_VERSION
    end
end
  