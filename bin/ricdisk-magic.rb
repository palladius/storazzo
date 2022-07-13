#!/usr/bin/env ruby

#require 'google/protobuf'
#require_relative '../etc/protos/out/ricdisk_pb'
require 'yaml'
require 'socket'
require 'optparse'       # http://ruby.about.com/od/advancedruby/a/optionparser.htm

# I believe this is wrong
#require 'storazzo'
# required to have methods wiothout self.
include 'lib/ric_disk'
extend Storazzo::Colors

if RUBY_VERSION.split('.')[0] == 1
  puts "Refusing to launch a script form Ruby 1. Sorry Ric, its 2020 damn it!"
  exit 2020
end

$PROG_VER = '0.3'
$DEBUG    = false

HISTORY = <<-BIG_LONG_MULTILINE
  2022-07-11 v0.3 Ported from private files in GIC into storazzo (open source on gitHub) and cleaned up italian and libs
  2022-07-DD v0.2 Some private stuff on GIC
BIG_LONG_MULTILINE

=begin

  ############################################################
  @author:    Riccardo Carlesso
  @email:     riccardo.carlesso@gmail.com
  @maturity:  development
  @language:  Ruby
  @synopsis:  Brief Description here
  @tags:      development, rcarlesso, test
  @description: See description
 ############################################################

=end


$myconf = {
    :app_name            => "RicDisk Magic should be sth like #{$0}",
    :description         => "
        This program is loosely inspired to ricdisk-magic.sh but its much better.
        Idea di base: trovare tutti le directory con file ricdisk e da esso estrarre info e magari METTERE info.
        Il tutto condito con un bel protobuf e un'entita che metto in Lib.
    ".strip.gsub(/^\s+/, "").gsub(/\s+$/, ""),
    # TODO move to some class default
    :media_dirs  => %w{ /media/riccardo/ /Volumes/ /mnt/ ~/git/storazzo/test/ /sobenme/giusto/per/imparare/ad/ammutolire/gli/errori/ }, 
    :mount_types => %w{ vfat ntfs }, 
}
$stats_file = "ricdisk_stats_v11.rds"
$gcs_bucket = 'palladius'

puts "First I need to figure out how to bring in all the libraries in here.."
exit(42)

# This template from scripta.rb. from 2.1.0 removed aby ric gem dependency.
# 2022-04-26 2.1.1  Added more colors
# 2022-04-26 2.1.0  Historical momemnt: removed gem 'ric' dependency
$TEMPLATE_VER = '2.1.1'


def usage(comment=nil)
  puts white($optparse.banner)
  puts($optparse.summarize)
  puts("Description: " + gray($myconf[:description]))
  puts red(comment) if comment
  #puts "Description: #{ $myconf[:description] }"
  exit 13
end

# include it in main if you want a custome one
def init()    # see lib_autoinit in lib/util.rb
  $opts = {}
  # setting defaults
  $opts[:verbose] = false
  $opts[:dryrun] = false
  $opts[:debug] = false
  $opts[:force] = false

  $optparse = OptionParser.new do |opts|
    opts.banner = "#{$0} v.#{$PROG_VER}\n Usage: #{File.basename $0} [options] file1 file2 ..."
    opts.on( '-d', '--debug', 'enables debug (DFLT=false)' )  {  $opts[:debug] = true ; $DEBUG = true }
    opts.on( '-f', '--force', 'force stuff (DFLT=false)' )  {  $opts[:force] = true  }
    opts.on( '-h', '--help', 'Display this screen' )          {  usage }
    #opts.on( '-j', '--jabba', 'Activates my Jabber powerful CLI' ) {  $opts[:jabba] = true  }
    opts.on( '-n', '--dryrun', "Don't really execute code" ) { $opts[:dryrun] = true }
    opts.on( '-l', '--logfile FILE', 'Write log to FILE' )    {|file| $opts[:logfile] = file }
    opts.on( '-v', '--verbose', 'Output more information' )   { $opts[:verbose] = true}
  end
  $optparse.parse!
end

def real_program
  deb("Hello world from a templated '#{yellow $0 }'")
  deb "+ Options are:  #{gray $opts}"
  deb "+ Depured args: #{azure ARGV}"
  deb "+ Script-specifig super-cool conf: #{green $prog_conf_d}"
  deb "+ Your configuration: #{purple $myconf.inspect}"

  # Your code goes here...
  puts white("Hello world from #{$myconf[:app_name]}!")
  puts "Description: '''#{white $myconf[:description] }'''"

  if ARGV == [] # empty -> ALL
    dirs = RicDisk.find_active_dirs()
    dirs.each {|dir| 
      RicDisk.sbrodola_ricdisk(dir)
      RicDisk.calculate_stats_files(dir) # dir is inutile
    } # TODO refactor in option sbrodola_afterwards=true. :)
  else
    deb "I consider ARGV come la lista di directories da parsare :)"
    dirs = RicDisk.find_active_dirs()
    ARGV.each{ |dir| 
      dir = File.expand_path(dir)
      if dirs.include?(dir)
        deb "Legit dir: #{green dir}"
        RicDisk.sbrodola_ricdisk(dir)
        RicDisk.calculate_stats_files(dir) # dir is inutile
      else
        deb "Figghiu ri buttana: doesnt exist #{red dir}" 
      end
    }
  end
end

def main(filename)
  deb "I'm called by #{white filename}"
  deb "HISTORY: #{gray HISTORY}"
  #deb "To remove this shit, just set $DEBUG=false :)"
  init        # Enable this to have command line parsing capabilities!
  #warn "[warn] template v#{$TEMPLATE_VER }: proviamo il warn che magari depreca il DEB"
  real_program
end

main(__FILE__)
