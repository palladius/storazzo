# Ric common stuff! :)
#
# Usage:
#      include Storazzo::Common  (def to def)
# or
#      extend Storazzo::Common   (def to def self.XX)
#
require_relative 'colors'

module Storazzo::Common 

    include Storazzo::Colors 


    def deb(s)
        puts "[DEB] #{yellow(s)}" if $DEBUG
    end
    def warn(s)
        puts "[WRN] #{azure(s)}"
    end
    def err(str)
        puts "[ERR] #{red(s)}"
    end
    def bug(s)
        puts "[🐛] #{gray s}"
    end

end