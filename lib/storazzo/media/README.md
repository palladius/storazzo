 
 Here I put all generic Media::Something classes. I can think of a few:

 * `LocalFolder`: the simplest and uselesser thing ever. Done mostly for troubleshooting
 * `MountFolder`: comes from mount, can get listed by mount, and usually has long latency
 * `GcsBucket`. From Google Cloud Storage. Why? Spoiler alert: It's my employer :) But happy to support more in the unlikely event this gem goes viral like *Corsivoe*.

 They all implement a few methods like:
 
 * `list_all`: shows all available objects in local system, leveraging the storazzo config file.
 * `parse`: parse the disk in initialized file. Then if system is writeable, writes in it the listing. If not, puts in a apposite folder defined by Storazzo.config.
 * `writeable?`: 
 * `local_mountpoint`: local path or mountpoint. The local variable shjould be 
    @local_mountpoint explicitly. TODO check this in abtsract class.