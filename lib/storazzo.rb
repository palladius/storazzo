# copied from https://guides.rubygems.org/make-your-own-gem/#introduction

#require 'storazzo/colors'

module StorazzoMod
    VERSION = File.read('./VERSION').chomp # "10.0.0"
    #require 'storazzo/translator'

    def latest_version 
        "1.2"
    end 
end 

class Storazzo
    # version 1.2
    def self.hi
      puts "Hello from Storazzo v#{StorazzoMod::VERSION rescue :ERROR}!"
    end
  end

require 'storazzo/translator'
