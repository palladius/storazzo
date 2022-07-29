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
        puts "[DEB🐞] #{yellow(s)}" if _debug_true # $DEBUG
    end
    # this has a yield
    def if_deb?()
        if _debug_true # $DEBUG
            deb "== yield START =="
            yield 
            deb "== yield END =="
        end
    end
    def warn(s)
        puts "[W⚠️RN] #{azure(s)}"
    end
    def err(str)
        puts "[ERR⛔] #{red(s)}"
    end
    def bug(s)
        puts "[🐛] #{gray s}"
    end
    def pverbose(is_verbose, str)
        puts "[V📚RB💀S📚] #{gray str}"
    end

private
    def _debug_true
        $DEBUG or ENV["DEBUG"] == 'true'
    end

#    puts "[DEBUG ENABLED!]" if _debug_true
end