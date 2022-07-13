# Use EXTEND vs INCLUDE and magically the Class will inherit instead of instance. Magical! :)
# http://www.railstips.org/blog/archives/2009/05/15/include-vs-extend-in-ruby/

module Storazzo 
    # needs to be defined before
end 

module Storazzo::Colors
  #class Storazzo::Colors1
    PREPEND_ME = "[Storazzo::Colors] "

    def deb(s);   puts "#DEB #{gray(s)}" if $DEBUG; end

    # colors 16
    def yellow(s)  "\033[1;33m#{s}\033[0m" ; end
    def gray(s)    "\033[1;30m#{s}\033[0m" ; end
    def green(s)   "\033[1;32m#{s}\033[0m" ; end
    def red(s)     "\033[1;31m#{s}\033[0m" ; end
    def blue(s)  "\033[1;34m#{s}\033[0m" ; end
    def purple(s)  "\033[1;35m#{s}\033[0m" ; end
    def azure(s)   "\033[1;36m#{s}\033[0m" ; end
    def white(s)   "\033[1;37m#{s}\033[0m" ; end

    # colors 64k
    def orange(s)   "\033[38;5;208m#{s}\033[0m" ; end

    # i dont undertstand why i need self :/
    # SELF version because I'm just stupid or lazy or both.
    # def self.yellow(s)  "#{PREPEND_ME}\033[1;33m#{s}\033[0m" ; end
    # def self.green(s)   "#{PREPEND_ME}\033[1;32m#{s}\033[0m" ; end
    #     def self.gray(s)    "#{PREPEND_ME}\033[1;30m#{s}\033[0m" ; end
    #     def self.green(s)   "#{PREPEND_ME}\033[1;32m#{s}\033[0m" ; end
    #     def self.red(s)     "#{PREPEND_ME}\033[1;31m#{s}\033[0m" ; end
    #     def self.blue(s)  "#{PREPEND_ME}\033[1;34m#{s}\033[0m" ; end
    #     def self.purple(s)  "#{PREPEND_ME}\033[1;35m#{s}\033[0m" ; end
    #     def self.azure(s)   "#{PREPEND_ME}\033[1;36m#{s}\033[0m" ; end
    #     def self.white(s)   "#{PREPEND_ME}\033[1;37m#{s}\033[0m" ; end
    
    # p<COLOR> Carlessian functions..
    def pwhite(s) puts(white(s)); end
    def pgreen(s) puts(green(s)); end
    def pred(s) puts(red(s)); end
    def pyellow(s) puts(yellow(s)); end

end
#end