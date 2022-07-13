# main entrypoint for tests and silly stuff from Makefile..
# This Class externalizes all relevant things from other libs while I learn how to do it from there
# eg from RicDisk.

module Storazzo

  # This is the Main Class - an entrypoint to call the meravilles hidden therein.
  #
  # Example:
  #   >> Storazzo.hi("ciao bello")
  #   => Hello from Storazzo v0.1.1!
  #
  # Arguments:
  #   message: (String) - optional


  class Storazzo::Main # Can be same name as Module: https://stackoverflow.com/questions/13261474/ruby-modules-and-classes-same-name-in-structure
    require 'storazzo/colors'
    extend Storazzo::Colors

    # version 1.2
    def self.hi(message=nil)
      str = "Hello from Storazzo v#{white Storazzo::version rescue "Error: #{$!}"}!"
      str += " Message: '#{yellow message.to_s}'" if message
      puts str 
      str 
    end

    def self.all_mounts(opts={})
        extend Storazzo::RicDisk
        opts_verbose = opts.fetch :verbose, true 

        pwhite "TODO(ricc): show a list of all RicDisk relevant mounts" if opts_verbose
        #sbrodola_ricdisk("/Volumes/")
        sbrodola_ricdisk(StorazzoMod::root + "./var/disks/") rescue "[Storazzo::AllMount] SomeError: #{$!}"
    end

    def self.all_tests        
        # include vs extend: https://stackoverflow.com/questions/15097929/ruby-module-require-and-include
        # => http://www.railstips.org/blog/archives/2009/05/15/include-vs-extend-in-ruby/
        #include Storazzo::Colors
        extend Storazzo::Colors

        pwhite "All tests BEGIN"
        deb "Maybe debug is enabled?"
        #puts "This is Storazzo v#{StorazzoMod::VERSION}"
        hi 
        # This works with EXTEND..
        puts(yellow "Just YELLOW 0")
        # This reqwuires a INCLUDE.
        #puts(Storazzo::Colors.yellow "Test YELLOW 1 self")
        #puts(Colors.yellow "Test YELLOW 1 self")
        #puts(Colors.green "Test YELLOW 2 ohne self")
        pwhite "All tests END"
        #puts "All tests END"
    end
  end
end