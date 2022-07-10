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
    require 'storazzo/colors'

    # version 1.2
    def self.hi
      puts "Hello from Storazzo v#{StorazzoMod::VERSION rescue :ERROR}!"
    end

    def self.all_tests        
        # include vs extend: https://stackoverflow.com/questions/15097929/ruby-module-require-and-include
        #include Storazzo::Colors
        extend Storazzo::Colors

        pwhite "All tests BEGIN"
        #puts "This is Storazzo v#{StorazzoMod::VERSION}"
        hi 
        puts(yellow "Just YELLOW 0")
        #puts(Storazzo::Colors.yellow "Test YELLOW 1 self")
        puts(Colors.yellow "Test YELLOW 1 self")
        puts(Colors.green "Test YELLOW 2 ohne self")
        pwhite "All tests END"
        #puts "All tests END"
    end
  end

require 'storazzo/translator'
