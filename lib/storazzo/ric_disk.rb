# A RicDisk wraps a local mount/disk/folder
# it's considered interesting if there's a ".ricdisk/.ricdisk"

module Storazzo
  class Storazzo::RicDisk 

    include Hashify
    extend Storazzo::Colors

 
      ## Instance variables

    # in order of finding, so the first will be the one we actually READ and use. I could looknat the date but cmon...
    @@config_files = %W{ ricdisk.yaml .ricdisk  } 
    @@ricdisk_version = '2.0'
    @@default_gemfile_test_disks_folder = Storazzo.root + "/var/test/disks/"
    # Immutable
    DEFAULT_MEDIA_FOLDERS = %w{ 
       /Volumes/ 
       /mnt/ 
     }.append(@@default_gemfile_test_disks_folder ).append("/media/#{ENV["USER"]}/" )

     #     # todo substitute with protobuf..
    attr_accessor :name, :description, :ricdisk_file, :local_mountpoint, :wr, :path, :ricdisk_file_empty, :size, :active_dirs


  ################################
  ## INSTANCE methods
  ################################


    def initialize(path, opts={})
      puts "[DEB] RicDisk initialize.. path=#{path}"
      @local_mountpoint = path
      @description = "This is an automated RicDisk description from v.#{@@ricdisk_version}. Created on #{Time.now}'"
      @ricdisk_version = @@ricdisk_version
      #@ricdisk_file = ricdisk_file
      @ricdisk_file = RicDisk.get_ricdisk_file(path)
      @ricdisk_file_empty = ricdisk_file_empty?
      @label = path.split("/").last
      @name = path.split("/").last
      #@wr = File.writable?("#{path}/#{ricdisk_file}" ) # .writeable?
      @tags = ['ricdisk', 'storazzo']
      @size = `du -s '#{path}'`.split(/\s/)[0] # self.size
      puts :beleza
      # @config = RicDiskConfig.instance.get_config
      # #puts @config if @config
      # find_info_from_mount(path)
      # find_info_from_df()
    end

    def ricdisk_file_empty?()
      File.empty?( "#{local_mountpoint}/#.ricdisk.yaml")
    end

    def ok_dir?
      not @ricdisk_file.nil?
    end


    def analyze_local_system()
      puts :TODO 
      puts "1. Interesting Mounts: #{green interesting_mount_points}"
      puts "2. Sbrodoling everything: :TODO"
      # find_info_from_mount(path)
      # find_info_from_df()
    end

    def path 
      local_mountpoint
    end

    def to_s 
      "RicDisk(paz=#{path}, writeable=#{writeable?}, size=#{size}B)"
    end

    # could take long..
    # def size 
    #   `du -s '#{path}'`.split(/\s/)[0]
    # end

    def writeable?() 
      :boh 
    end

  ################################
  ## CLASS methods
  ################################


    # All places where to find for something :)
    def self.default_media_folders
      DEFAULT_MEDIA_FOLDERS
    end


    def self.test # _localgem_disks
      d = RicDisk.new( @@default_gemfile_test_disks_folder)
      puts (d)
      puts "do something with it: #{d}"
      #d.find_active_dirs()
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
            puts "DEB Subdir: #{subdir}"
            puts `ls -al "#{subdir}"`
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

    
    # new
    def self.get_ricdisk_file(path)
      puts "RICC_WARNING TODO use @@config_files instead"
      return ".ricdisk.yaml" if File.exist?("#{path}/.ricdisk.yaml") #and File.empty?( "#{path}/.ricdisk.yaml")
      return ".ricdisk" if File.exist?("#{path}/.ricdisk") # and File.empty?( "#{path}/.ricdisk")
      return nil
    end

  
    def self.interesting_mount_points(opts={})
      #https://unix.stackexchange.com/questions/177014/showing-only-interesting-mount-points-filtering-non-interesting-types
      `mount | grep -Ev 'type (proc|sysfs|tmpfs|devpts|debugfs|rpc_pipefs|nfsd|securityfs|fusectl|devtmpfs) '`.split(/\n+/)
    end

    # maybe move to a RiccFile class? Maybe even INHERIT from FILE?
    def self.obsolescence_seconds file_path
      creation_time = File.stat(file_path).ctime
      deb("[obsolescence_seconds] File #{file_path}: #{creation_time} - #{(Time.now - creation_time)} seconds ago")
      (Time.now - creation_time).to_i
    end
    # maybe move to a RiccFile class? Maybe even INHERIT from FILE?
    def self.obsolescence_days(file_path)
      return obsolescence_seconds(file_path) / 86400
    end


    # FORMER SBRODOLA, now write_config_yaml_to_disk
    def self.write_config_yaml_to_disk(subdir) # sbrodola_ricdisk(subdir)
      # given a path, if .ricdisk exists i do stuff with it..
      disk_info = nil
      unless self.ok_dir?(subdir)
        puts("Nothing for me here: '#{subdir}'. Existing")
        return 
      end
      if File.exists?( "#{subdir}/.ricdisk") and File.empty?( "#{subdir}/.ricdisk")
        deb("Interesting1. Empty file! Now I write YAML with it.")
        disk_info = RicDisk.new(subdir, '.ricdisk')
      end
      if File.exists?( "#{subdir}/.ricdisk.yaml") and File.empty?( "#{subdir}/.ricdisk.yaml")
        deb("Interesting2. Empty file! TODO write YAML with it.")
        disk_info = RicDisk.new(subdir, '.ricdisk.yaml')
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

    # TODO obsolete this as i should NOT be calling it from clas, but from method.
    def self.ok_dir?(subdir)
      File.exists?( "#{subdir}/.ricdisk") or File.exists?( "#{subdir}/.ricdisk.yaml")
    end
  


    # Create RDS file.
    def self.calculate_stats_files(dir, opts={})
      opts_upload_to_gcs = opts.fetch :upload_to_gcs, true 
      full_file_path = "#{dir}/#{$stats_file}"
      return "This refacgtor is for another day"
  
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
        command = "find . -print0 | xargs -0 stats-with-md5.rb --no-color | tee '#{full_file_path}'"
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
  
  
  


  
#     def self.backquote_execute(cmd)
#       # executed a command wrapped by dryrun though
#       return "DRYRUN backquote_execute(#{cmd})" if $opts[:dryrun]
#       `#{cmd}`
#     end
    
#     def self.upload_to_gcs(file, opts={})
#       deb("upload_to_gcs(#{file}). TODO(ricc) after breafast upload to GCS : #{file}")
#       mount_name = file.split('/')[-2]
#       filename = "#{mount_name}-#{File.basename file}"
#       hostname = Socket.gethostname[/^[^.]+/]
#       command = "gsutil cp '#{file}' gs://#{$gcs_bucket}/backup/ricdisk-magic/#{ hostname }-#{filename}"
#       deb("Command: #{command}")
#       ret = backquote_execute(command)
#       # if $opts[:debug] do
#       #   puts "+ Current list of files:"
#       #   ret = backquote_execute("gsutil ls -al gs://#{$gcs_bucket}/backup/ricdisk-magic/")
#       #   puts ret
#       # end
#       ret
#     end
  