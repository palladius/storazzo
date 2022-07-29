# A RicDisk wraps a local mount/disk/folder
# it's considered interesting if there's a ".ricdisk/.ricdisk"

require 'digest'

module Storazzo
  class Storazzo::RicDisk 

    include Hashify
    include Storazzo::Common 
    extend Storazzo::Colors
    require 'socket'

 
      ## Instance variables

    # in order of finding, so the first will be the one we actually READ and use. I could looknat the date but cmon...
    # These are the files I do accept.
    ConfigFiles = %W{ ricdisk.yaml .ricdisk storazzo.yaml } 
    DefaultConfigFile = "storazzo.yaml" # .ricdisk } 
    RicdiskVersion = '2.1'
    RicdiskHistory = [
      '2022-07-29 2.1 Added timestamp',
      '2022-07-28 2.0 Added tags, siz, unique_hash, computation_hostname, wr, ...',
  ]
    DefaultGemfileTestDiskFolder = Storazzo.root + "/var/test/disks/" # was: @@default_gemfile_test_disks_folder
    # Immutable
    DefaultMediaFolders = %w{ 
       /Volumes/ 
       /mnt/ 
     }.append(DefaultGemfileTestDiskFolder ).append("/media/#{ENV["USER"]}/" )

     #     # todo substitute with protobuf..
    attr_accessor :name, :description, :ricdisk_file, :ricdisk_file_full, :local_mountpoint, :wr, :path, 
                  :ricdisk_file_empty, :size, :active_dirs, :ricdisk_version, 
                  :unique_hash # new 202207


  ################################
  ## INSTANCE methods
  ################################


    def initialize(path, opts={})
      deb "RicDisk initialize.. path=#{path}"
      @local_mountpoint = File.expand_path(path)
      @description = "This is an automated RicDisk description from v.#{RicdiskVersion}. Created on #{Time.now}'"
      @ricdisk_version = RicdiskVersion
      @ricdisk_file = compute_ricdisk_file() # Storazzo::RicDisk.get_ricdisk_file(path)
      @ricdisk_file_full = "#{@local_mountpoint}/#{@ricdisk_file}"
      @label = path.split("/").last
      @name = path.split("/").last
      #@wr = File.writable?("#{path}/#{ricdisk_file}" ) # .writeable?
      #@wr = writeable?
      @tags = ['ricdisk', 'storazzo']
      @size = `du -s '#{path}'`.split(/\s/)[0] # self.size
      @unique_hash = "MD5::" + Digest::MD5.hexdigest(File.expand_path(path)) #   hash = Digest::MD5.hexdigest(File.expand_path(get_local_mountpoint))
      @computation_hostname = Socket.gethostname
      @created_at = Time.now

      @ricdisk_file_empty = ricdisk_file_empty?
      
      # @config = RicDiskConfig.instance.get_config
      # #puts @config if @config
      # find_info_from_mount(path)
      deb "RicDisk initialize. to_s: #{self}"
      # find_info_from_df()
    end

    def ricdisk_file_empty?()
      #      File.empty?("#{local_mountpoint}/.ricdisk.yaml")
      puts "compute_ricdisk_file: #{compute_ricdisk_file}"
      File.empty?(compute_ricdisk_file.to_s) # was (get_ricdisk_file)
    end

    def ok_dir?
      not ricdisk_file.nil?
    end


    def analyze_local_system()
      puts "TODO This should analyzze the WHOLE system. TODO(ricc): move to another object which has to do with the system/computer."
      puts "1. Interesting Mounts: #{green interesting_mount_points}"
      puts "2. Sbrodoling everything: :TODO"
      # find_info_from_mount(path)
      # find_info_from_df()
    end

    def path 
      local_mountpoint
    end

    def to_s 
      "RicDisk(paz=#{path}, r/w=#{writeable?}, size=#{size}B, f=#{ricdisk_file}, v#{ricdisk_version})"
    end

    # could take long..
    # def size 
    #   `du -s '#{path}'`.split(/\s/)[0]
    # end

    def writeable?() 
      return @wr unless @wr.nil? 
      # Otherwise I can do an EXPENSIVE calculation
      puts yellow("TODO(ricc): Do expensive calculation if this FS is writeable: #{path} and write/memoize it on @wr once and for all")
      puts yellow("TODO(ricc): I have a feeling this should be delegated to praecipuus Storazzo::Media::Object we refer to (WR is different on GCS vs Local) : #{self.to_verbose_s}")
      #@wr = File.writable?(File.expand_path(@ricdisk_file)) # rescue false
      raise "for some reason an important info (ricdisk_file='#{absolute_path}') is missing!" if ricdisk_file.nil?
      @wr = File.writable?(absolute_path) # rescue false
      return @wr
      #:boh_todo_fix_me_and_compute
      #false
    end

    def to_verbose_s 
      h = {}
      h[:to_s] = self.to_s
      h[:wr] = self.wr
      h[:inspect] = self.inspect
      h[:writeable] = self.writeable?
      return h
    end

  ################################
  ## CLASS methods
  ################################


    # All places where to find for something :)
    def self.default_media_folders
      DefaultMediaFolders # was DEFAULT_MEDIA_FOLDERS
    end


    def self.test # _localgem_disks
      d = RicDisk.new( DefaultGemfileTestDiskFolder)
      puts (d)
      puts "do something with it: #{d}"
      #d.find_active_dirs()
    end

    def absolute_path
      #@local_mountpoint + "/" +  @ricdisk_file
      "#{local_mountpoint}/#{ricdisk_file}"
    end
  
    def self.find_active_dirs(base_dirs=nil, also_mountpoints=true)
      if base_dirs.nil?
        base_dirs = default_media_folders 
        puts "find_active_dirs with empty input -> using default_media_folders: #{yellow default_media_folders}"
      end
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
            deb "Subdir: #{subdir}"
            puts `ls -al "#{subdir}"` # TODO refactor in exec
            active_dirs << subdir if ok_dir? # self.ok_dir?(subdir)
          }
          #puts(white x)
        rescue Exception => e # optionally: `rescue Exception => ex`
          puts "Exception: '#{e}'"
        ensure # will always get executed
          #deb 'Always gets executed.'
          #x = []
        end 
      end
    end

    def compute_ricdisk_file()
      unless @ricdisk_file.nil?
        deb "[CACHE HIT] ricdisk_file (didnt have to recompute it - yay!)"
        return @ricdisk_file
      end
      deb "[compute_ricdisk_file] RICC_WARNING This requires cmputation I wanna do it almost once"
      ConfigFiles.each do |papable_config_filename|
        #return ".ricdisk.yaml" if File.exist?("#{path}/.ricdisk.yaml") #and File.empty?( "#{path}/.ricdisk.yaml")
        #return ".ricdisk" if File.exist?("#{path}/.ricdisk") # and File.empty?( "#{path}/.ricdisk")
        return papable_config_filename if File.exist?("#{path}/#{papable_config_filename}") # and File.empty?( "#{path}/.ricdisk")
      end
      deb "File not found! Neither #{ConfigFiles} exist.."
#      return nil
      return DefaultConfigFile
    end


    # def self.compute_ricdisk_file_by_path_once(path)
    #   # unless @ricdisk_file.nil?
    #   #   deb "[CACHE HIT] ricdisk_file (didnt have to recompute it - yay!)"
    #   #   return @ricdisk_file
    #   # end
    #   warn "RICC_WARNING This requires cmputation I wanna do it almost once"
    #   ConfigFiles.each do |papable_config_filename|
    #     #return ".ricdisk.yaml" if File.exist?("#{path}/.ricdisk.yaml") #and File.empty?( "#{path}/.ricdisk.yaml")
    #     #return ".ricdisk" if File.exist?("#{path}/.ricdisk") # and File.empty?( "#{path}/.ricdisk")
    #     return papable_config_filename if File.exist?("#{path}/#{papable_config_filename}") # and File.empty?( "#{path}/.ricdisk")
    #   end
    #   return nil
    # end

    
    # # new
    # def self.get_ricdisk_file_obsolete(path)
    #   if @ricdisk_file
    #     puts "[CACHE HIT] ricdisk_file"
    #     return @ricdisk_file
    #   end
    #   puts "RICC_WARNING This requires cmputation I wanna do it almost once"
    #   ConfigFiles.each do |papable_config_filename|
    #     #return ".ricdisk.yaml" if File.exist?("#{path}/.ricdisk.yaml") #and File.empty?( "#{path}/.ricdisk.yaml")
    #     #return ".ricdisk" if File.exist?("#{path}/.ricdisk") # and File.empty?( "#{path}/.ricdisk")
    #     return papable_config_filename if File.exist?("#{path}/#{papable_config_filename}") # and File.empty?( "#{path}/.ricdisk")
    #   end
    #   return nil
    # end

  
    def self.interesting_mount_points(opts={})
      #https://unix.stackexchange.com/questions/177014/showing-only-interesting-mount-points-filtering-non-interesting-types
      `mount | grep -Ev 'type (proc|sysfs|tmpfs|devpts|debugfs|rpc_pipefs|nfsd|securityfs|fusectl|devtmpfs) '`.split(/\n+/)
    end

    # maybe move to a RiccFile class? Maybe even INHERIT from FILE?
    def obsolescence_seconds(file_path)
      creation_time = File.stat(file_path).ctime
      deb("[obsolescence_seconds] File #{file_path}: #{creation_time} - #{(Time.now - creation_time)} seconds ago")
      (Time.now - creation_time).to_i
    end
    # maybe move to a RiccFile class? Maybe even INHERIT from FILE?
    def obsolescence_days(file_path)
      return obsolescence_seconds(file_path) / 86400
    end


    # FORMER SBRODOLA, now write_config_yaml_to_disk
    #def self.write_config_yaml_to_disk(subdir, opts={}) # sbrodola_ricdisk(subdir)
    def write_config_yaml_to_disk(subdir, opts={}) # sbrodola_ricdisk(subdir)
      # given a path, if .ricdisk exists i do stuff with it..
      disk_info = nil
      unless ok_dir? # self.ok_dir?(subdir)
        puts("[write_config_yaml_to_disk] Nothing for me here: '#{subdir}'. Existing")
        return 
      end
      ConfigFiles.each do |papable_configfile_name|
        if File.exists?( "#{subdir}/#{papable_configfile_name}") and File.empty?( "#{subdir}/#{papable_configfile_name}")
          deb("Interesting. Empty file '#{papable_configfile_name}'! Now I write YAML with it.")
          disk_info = RicDisk.new(subdir, papable_configfile_name)
        end
      end
      # if File.exists?( "#{subdir}/.ricdisk") and File.empty?( "#{subdir}/.ricdisk")
      #   deb("Interesting1. Empty file! Now I write YAML with it.")
      #   disk_info = RicDisk.new(subdir, '.ricdisk')
      # end
      # if File.exists?( "#{subdir}/.ricdisk.yaml") and File.empty?( "#{subdir}/.ricdisk.yaml")
      #   deb("Interesting2. Empty file! TODO write YAML with it.")
      #   disk_info = RicDisk.new(subdir, '.ricdisk.yaml')
      #   puts(yellow disk_info.to_yaml)
      # end
      if disk_info.is_a?(RicDisk)
        deb yellow("disk_info.class: #{disk_info.class}")
        if File.empty?(disk_info.absolute_path) # and (disk_info.wr)
          puts(green("yay, we can now write the file '#{disk_info.absolute_path}' (which is R/W, I just checked!) with proper YAML content.."))
          if disk_info.wr
            ret = File.write(disk_info.absolute_path, disk_info.obj_to_yaml)
            puts green("Written file! ret=#{ret}")
          else
            raise "TODO_IMPLEMENT: write in proper place in config dir"
            puts red("TODO implement me")
          end
        else
          puts(red("Something not right here: either file is NOT empty or disk is NOT writeable.. #{File.empty?(disk_info.absolute_path)}"))
          puts("File size: #{File.size(disk_info.absolute_path)}")
          puts(disk_info.to_s)
          puts(disk_info.obj_to_hash)
          puts(disk_info.obj_to_yaml)
        end
      else # not a RicDisk..
        puts "[write_config_yaml_to_disk] No DiskInfo found across #{ConfigFiles}. I leave this function empty-handed."
      end

      #disk_info.absolute_path
      #if File.exists?( "#{subdir}/.ricdisk") and ! File.empty?( "#{subdir}/.ricdisk")
      # if File.exists?(disk_info.absolute_path) and ! File.empty?(disk_info.absolute_path)
      #   puts("Config File found with old-style name: '#{subdir}/.ricdisk' ! Please move it to .ricdisk.yaml!")
      #   puts(white `cat "#{disk_info.absolute_path}"`)
      # else
      #   puts "WRITING NOW. [I BELIEVE THIS IS DUPE CODE - see a few lines above!] disk_info.obj_to_yaml .. to #{compute_ricdisk_file}"
      #   File.open(ricdisk_file_full, 'w').write(disk_info.obj_to_yaml)
      # end
    end

    # TODO obsolete this as i should NOT be calling it from clas, but from method.
    def self.ok_dir?(subdir)
      File.exists?( "#{subdir}/.ricdisk") or File.exists?( "#{subdir}/.ricdisk.yaml")
    end

    def compute_stats_files(opts={})
      puts azure("[compute_stats_files] TODO implement natively. Now I'm being lazy")
      #Storazzo::RicDisk.calculate_stats_files(path, opts)
      opts_upload_to_gcs = opts.fetch :upload_to_gcs, true
      dir = path
      
      full_file_path = "#{dir}/#{$stats_file}"
      #return "This refactor is for another day"
  
      puts("compute_stats_files(#{white dir}): #{white full_file_path}")
      puts "TEST1 DIR EXISTS: #{dir} -> #{File.directory? dir}"
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
        command = "find . -print0 | xargs -0 stats-with-md5 --no-color | tee '#{full_file_path}'"
        puts("[#{`pwd`.chomp}] Executing: #{azure command}")
        ret = backquote_execute(command)
        puts "Done. #{ret.split("\n").count} files processed."
      end
    end
  


    # Create RDS file.
    def self.calculate_stats_files(dir, opts={})
      opts_upload_to_gcs = opts.fetch :upload_to_gcs, true
      
      full_file_path = "#{dir}/#{$stats_file}"
      return "This refactor is for another day"
  
      puts("calculate_stats_files(#{white dir}): #{white full_file_path}")
      puts "TEST1 DIR EXISTS: #{dir} -> #{File.directory? dir}"
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
        command = "find . -print0 | xargs -0 stats-with-md5 --no-color | tee '#{full_file_path}'"
        puts("[#{`pwd`.chomp}] Executing: #{azure command}")
        ret = backquote_execute command
        puts "Done. #{ret.split("\n").count} files processed."
      end
    end
  
#       if also_mountpoints
# =begin
#   Example output from mount:

#   devfs on /dev (devfs, local, nobrowse)
#   /dev/disk3s6 on /System/Volumes/VM (apfs, local, noexec, journaled, noatime, nobrowse)
#   /dev/disk3s2 on /System/Volumes/Preboot (apfs, local, journaled, nobrowse)
#   /dev/disk3s4 on /System/Volumes/Update (apfs, local, journaled, nobrowse)
#   /dev/disk1s2 on /System/Volumes/xarts (apfs, local, noexec, journaled, noatime, nobrowse)
#   /dev/disk1s1 on /System/Volumes/iSCPreboot (apfs, local, journaled, nobrowse)
#   /dev/disk1s3 on /System/Volumes/Hardware (apfs, local, journaled, nobrowse)
#   /dev/disk3s5 on /System/Volumes/Data (apfs, local, journaled, nobrowse, protect)
#   map auto_home on /System/Volumes/Data/home (autofs, automounted, nobrowse)
#   //riccardo@1.0.1.10/video on /Volumes/video (afpfs, nodev, nosuid, mounted by ricc)
#   //riccardo@1.0.1.10/photo on /Volumes/photo (afpfs, nodev, nosuid, mounted by ricc)
# =end
#           # add directories from current mountpoints...
#           mount_table_lines = interesting_mount_points()
#           mount_table_lines.each{|line|
#             next if line =~ /^map /
#             dev, on, path, mode = line.split(/ /)
#             #puts line
#             #deb yellow(path)
#             active_dirs << path if self.ok_dir?(path)
#           }
#         end
#         active_dirs.uniq!
#         puts("find_active_dirs(): found dirs " + green(active_dirs))
#         return active_dirs
#       end
    


  end #/Class
end  #/Module


  

  
#     def initialize(path, ricdisk_file)
#       puts "[DEB] RicDisk initialize.. path=#{path}"
#       @local_mountpoint = path
#       @description = "This is an automated RicDisk description from v.#{VERSION}. Riccardo feel free to edit away with characteristicshs of this device.. Created on #{Time.now}'"
#       @ricdisk_version = VERSION
#       @ricdisk_file = ricdisk_file
#       #@questo_non_esiste = :sobenme
#       @label = path.split("/").last
#       @name = path.split("/").last
#       @wr = File.writable?("#{path}/#{ricdisk_file}" ) # .writeable?
#       @tags = 'ricdisk'
#       puts :beleza
#       @config = RicDiskConfig.instance.get_config
#       #puts @config if @config
#       find_info_from_mount(path)
#       find_info_from_df()
#     end
  
#     def ricdisk_absolute_path
#       @local_mountpoint + "/" +  @ricdisk_file
#     end
  
#     def add_tag(tag)
#       @tags += ", #{tag}"
#     end
  
#     # might have other things in the future...
#     def find_info_from_mount(path)
#       mount_table_lines = interesting_mount_points()
#       mount_line = nil
#       mount_table_lines.each do |line|
#         next if line =~ /^map /
#         dev, on, mount_path, mode = line.split(/ /)
#         if mount_path==path
#           mount_line = line 
#         else
#           @info_from_mount = false      
#         end
#       end
#       @info_from_mount = ! (mount_line.nil?)
#       if @info_from_mount
#         #@mount_line = mount_line
#         @description += "\nMount line:\n" + mount_line
#         @remote_mountpoint = mount_line.split(/ /)[0]
#         @fstype = mount_line.split(/ /)[3].gsub(/[\(,]/, '')
#         add_tag(:synology) if @remote_mountpoint.match('1.0.1.10')
#       end
#     end
  
#     def find_info_from_df()
#       path = @local_mountpoint
#       df_info = `df -h "#{path}"`
#       @df_info = df_info
#       lines = df_info.split(/\n+/)
#       raise "I need exactly TWO lines! Or no info is served here..." unless lines.size == 2
#       mount, @size_readable, used_size, avail_size, @disk_utilization, other =  lines[1].split(/\s+/) # second line..
#     end
  
  
  


  
    def backquote_execute(cmd, opts={})
      dryrun = opts.fetch :dryrun, false
      # executed a command wrapped by dryrun though
      return "DRYRUN backquote_execute(#{cmd})" if dryrun # $opts[:dryrun]
      `#{cmd}`
    end
    
    def upload_to_gcs(file, opts={})
      deb("upload_to_gcs(#{file}). TODO(ricc) after breafast upload to GCS : #{file}")
      mount_name = file.split('/')[-2]
      filename = "#{mount_name}-#{File.basename file}"
      hostname = Socket.gethostname[/^[^.]+/]
      command = "gsutil cp '#{file}' gs://#{$gcs_bucket}/backup/ricdisk-magic/#{ hostname }-#{filename}"
      deb("Command: #{command}")
      puts azure("GCS upload disabled until I know if it works :) command='#{command}'")
      ret = backquote_execute(command, :dryrun => true)
      # if $opts[:debug] do
      #   puts "+ Current list of files:"
      #   ret = backquote_execute("gsutil ls -al gs://#{$gcs_bucket}/backup/ricdisk-magic/")
      #   puts ret
      # end
      ret
    end
  