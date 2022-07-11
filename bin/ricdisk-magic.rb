#!/usr/bin/env ruby

#require 'google/protobuf'
#require_relative '../etc/protos/out/ricdisk_pb'
require 'yaml'
require 'socket'
require 'optparse'       # http://ruby.about.com/od/advancedruby/a/optionparser.htm
require 'storazzo'
# required to have methods wiothout self.
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

# This template from scripta.rb. from 2.1.0 removed aby ric gem dependency.
# 2022-04-26 2.1.1  Added more colors
# 2022-04-26 2.1.0  Historical momemnt: removed gem 'ric' dependency
$TEMPLATE_VER = '2.1.1'

# copied from https://dev.to/ayushn21/how-to-generate-yaml-from-ruby-objects-without-type-annotations-4fli
module Hashify
  # Classes that include this module can exclude certain
  # instance variable from its hash representation by overriding
  # this method
  def ivars_excluded_from_hash
    [ 'this_doesnt_exist' ]
  end

  def to_hash
    hash = {}
    excluded_ivars = ivars_excluded_from_hash

    # Iterate over all the instance variables and store their
    # names and values in a hash
    instance_variables.each do |var|
      next if excluded_ivars.include? var.to_s

      value = instance_variable_get(var)
      value = value.map(&:to_hash) if value.is_a? Array

      hash[var.to_s.delete("@")] = value
    end

    return hash
  end

  def to_yaml 
    to_hash.to_yaml
  end
end

# TODO move to lib/ric_disk/
class RicDisk 
  VERSION = "1.0"
  include Hashify
  extend Storazzo::Colors


  # todo substitute wqith protobuf..
  attr_accessor :name, :description, :ricdisk_file, :local_mountpoint, :wr

  def self.interesting_mount_points(opts={})
    #https://unix.stackexchange.com/questions/177014/showing-only-interesting-mount-points-filtering-non-interesting-types
    `mount | grep -Ev 'type (proc|sysfs|tmpfs|devpts|debugfs|rpc_pipefs|nfsd|securityfs|fusectl|devtmpfs) '`.split(/\n+/)
  end

  def initialize(path, ricdisk_file)
    @local_mountpoint = path
    @description = "This is an automated RicDisk description from v.#{VERSION}. Riccardo feel free to edit away with characteristicshs of this device.. Created on #{Time.now}'"
    @ricdisk_version = VERSION
    @ricdisk_file = ricdisk_file
    #@questo_non_esiste = :sobenme
    @label = path.split("/").last
    @name = path.split("/").last
    @wr = File.writable?("#{path}/#{ricdisk_file}" ) # .writeable?
    @tags = 'ricdisk'
    find_info_from_mount(path)
    find_info_from_df()
  end

  def ricdisk_absolute_path
    @local_mountpoint + "/" +  @ricdisk_file
  end

  def add_tag(tag)
    @tags += ", #{tag}"
  end

  # might have other things in the future...
  def find_info_from_mount(path)
    mount_table_lines = interesting_mount_points()
    mount_line = nil
    mount_table_lines.each do |line|
      next if line =~ /^map /
      dev, on, mount_path, mode = line.split(/ /)
      if mount_path==path
        mount_line = line 
      else
        @info_from_mount = false      
      end
    end
    @info_from_mount = ! (mount_line.nil?)
    if @info_from_mount
      #@mount_line = mount_line
      @description += "\nMount line:\n" + mount_line
      @remote_mountpoint = mount_line.split(/ /)[0]
      @fstype = mount_line.split(/ /)[3].gsub(/[\(,]/, '')
      add_tag(:synology) if @remote_mountpoint.match('1.0.1.10')
    end
  end

  def find_info_from_df()
    path = @local_mountpoint
    df_info = `df -h "#{path}"`
    @df_info = df_info
    lines = df_info.split(/\n+/)
    raise "I need exactly TWO lines! Or no info is served here..." unless lines.size == 2
    mount, @size_readable, used_size, avail_size, @disk_utilization, other =  lines[1].split(/\s+/) # second line..
  end



  def self.sbrodola_ricdisk(subdir)
    # given a path, if .ricdisk exists i do stuff with it..
    disk_info = nil
    unless self.ok_dir?(subdir)
      puts("Nothing for me here. Existing")
      return 
    end
    if File.exists?( "#{subdir}/.ricdisk") and File.empty?( "#{subdir}/.ricdisk")
      deb("Interesting1. Empty file! Now I write YAML with it.")
      disk_info = RicDisk.new(subdir, '.ricdisk')
      #puts(x)
      #puts(yellow x.to_yaml)
    end
    if File.exists?( "#{subdir}/.ricdisk.yaml") and File.empty?( "#{subdir}/.ricdisk.yaml")
      deb("Interesting2. Empty file! TODO write YAML with it.")
      disk_info = RicDisk.new(subdir, '.ricdisk.yaml')
      # todo write
      #puts(x)
      puts(yellow disk_info.to_yaml)
    end
    if disk_info
      if File.empty?(disk_info.ricdisk_absolute_path) and (disk_info.wr)
        puts(green("yay, we can now write the file '#{disk_info.ricdisk_absolute_path}' (which is R/W, I just checked!) with proper YAML content.."))
        ret = File.write(disk_info.ricdisk_absolute_path, disk_info.to_yaml)
        puts("Written file! ret=#{ret}")
      else
        puts(red("Nope, qualcosa non va.. #{File.empty?(disk_info.ricdisk_absolute_path)}"))
        puts("File size: #{File.size(disk_info.ricdisk_absolute_path)}")
      end
    end
    if File.exists?( "#{subdir}/.ricdisk") and ! File.empty?( "#{subdir}/.ricdisk")
      puts("Config File found with old-style name: '#{subdir}/.ricdisk' !")
      #puts(white `cat "#{subdir}/.ricdisk"`)
    end
  end

  # separiamo cosi usiamo meglio...
  def self.ok_dir?(subdir)
    File.exists?( "#{subdir}/.ricdisk") or File.exists?( "#{subdir}/.ricdisk.yaml")
  end

  def self.obsolescence_seconds file_path
    creation_time = File.stat(file_path).ctime
    deb("[obsolescence_seconds] File #{file_path}: #{creation_time} - #{(Time.now - creation_time)} seconds ago")
    (Time.now - creation_time).to_i
  end
  def self.obsolescence_days(file_path)
    return obsolescence_seconds(file_path) / 86400
  end

  def self.backquote_execute(cmd)
    # executed a command wrapped by dryrun though
    return "DRYRUN backquote_execute(#{cmd})" if $opts[:dryrun]
    `#{cmd}`
  end
  
  def self.upload_to_gcs(file, opts={})
    deb("upload_to_gcs(#{file}). TODO(ricc) after breafast upload to GCS : #{file}")
    mount_name = file.split('/')[-2]
    filename = "#{mount_name}-#{File.basename file}"
    hostname = Socket.gethostname[/^[^.]+/]
    command = "gsutil cp '#{file}' gs://#{$gcs_bucket}/backup/ricdisk-magic/#{ hostname }-#{filename}"
    deb("Command: #{command}")
    ret = backquote_execute(command)
    # if $opts[:debug] do
    #   puts "+ Current list of files:"
    #   ret = backquote_execute("gsutil ls -al gs://#{$gcs_bucket}/backup/ricdisk-magic/")
    #   puts ret
    # end
    ret
  end

  # Create RDS file.
  def self.calculate_stats_files(dir, opts={})
    opts_upload_to_gcs = opts.fetch :upload_to_gcs, true 
    full_file_path = "#{dir}/#{$stats_file}"

    puts("calculate_stats_files(#{white dir}): #{white full_file_path}")
    puts "TEST1 DIR EXISTS: #{dir} -> #{Dir.directory? dir}"
    Dir.chdir(dir)
    if File.exists?(full_file_path) and ($opts[:force] == false)
      puts "File '#{$stats_file}' exists already." #  - now should see if its too old, like more than 1 week old"
      # TODO check for file time...
      print "Lines found: #{yellow `wc -l "#{full_file_path}" `.chomp }. File obsolescence (days): #{yellow obsolescence_days(full_file_path)}."
      if obsolescence_days(full_file_path) > 7 
        puts("*** ACHTUNG *** FIle is pretty old. You might consider rotating: #{yellow "mv #{full_file_path} #{full_file_path}_old"}. Or invoke with --force")
      end
      upload_to_gcs(full_file_path) if opts_upload_to_gcs
    else
      puts "Crunching data stats from '#{dir}' into '#{$stats_file}' ... please bear with me.. [maybe file didnt exist, maybe $opts[:force] is true]" 
      command = "find . -print0 | xargs -0 stats-with-md5.rb --no-color | tee '#{full_file_path}'"
      puts("[#{`pwd`.chomp}] Executing: #{azure command}")
      ret = backquote_execute command
      puts "Done. #{ret.split("\n").count} files processed."
    end
  end

  def self.find_active_dirs(base_dirs=nil, also_mountpoints=true)
    base_dirs = $myconf[:media_dirs] if base_dirs.nil? 
    active_dirs = []
    base_dirs.each do |ugly_dir| 
      # https://stackoverflow.com/questions/1899072/getting-a-list-of-folders-in-a-directory#:~:text=Dir.chdir(%27/destination_directory%27)%0ADir.glob(%27*%27).select%20%7B%7Cf%7C%20File.directory%3F%20f%7D
      dir = File.expand_path(ugly_dir)
      begin
        x=[]
#        puts "TEST2 DIR EXISTS: #{dir} -> #{Dir.exists?(dir)}"
        unless Dir.exists?(dir)
          deb "Dir doesnt exist, skipping: #{dir}"
          next 
        end
        Dir.chdir(dir) 
        x = Dir.glob('*').select {|f| File.directory? f}
        subdirs = x.map{|subdir|   "#{dir}#{subdir}"}
        subdirs.each{|subdir| 
          #puts `ls -al "#{subdir}"`
          active_dirs << subdir if self.ok_dir?(subdir)
        }
        #puts(white x)
      rescue Exception => e # optionally: `rescue Exception => ex`
        puts "Exception: '#{e}'"
      ensure # will always get executed
        #deb 'Always gets executed.'
        #x = []
      end 
    end

    if also_mountpoints
=begin
  Example output from mount:

  devfs on /dev (devfs, local, nobrowse)
  /dev/disk3s6 on /System/Volumes/VM (apfs, local, noexec, journaled, noatime, nobrowse)
  /dev/disk3s2 on /System/Volumes/Preboot (apfs, local, journaled, nobrowse)
  /dev/disk3s4 on /System/Volumes/Update (apfs, local, journaled, nobrowse)
  /dev/disk1s2 on /System/Volumes/xarts (apfs, local, noexec, journaled, noatime, nobrowse)
  /dev/disk1s1 on /System/Volumes/iSCPreboot (apfs, local, journaled, nobrowse)
  /dev/disk1s3 on /System/Volumes/Hardware (apfs, local, journaled, nobrowse)
  /dev/disk3s5 on /System/Volumes/Data (apfs, local, journaled, nobrowse, protect)
  map auto_home on /System/Volumes/Data/home (autofs, automounted, nobrowse)
  //riccardo@1.0.1.10/video on /Volumes/video (afpfs, nodev, nosuid, mounted by ricc)
  //riccardo@1.0.1.10/photo on /Volumes/photo (afpfs, nodev, nosuid, mounted by ricc)
=end
        # add directories from current mountpoints...
        mount_table_lines = interesting_mount_points()
        mount_table_lines.each{|line|
          next if line =~ /^map /
          dev, on, path, mode = line.split(/ /)
          #puts line
          #deb yellow(path)
          active_dirs << path if self.ok_dir?(path)
        }
      end
      active_dirs.uniq!
      puts("find_active_dirs(): found dirs " + green(active_dirs))
      return active_dirs
    end
  

end

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
