# rsync

Remote file copy (Synchronize file trees).

With macOS Sequoia, Apple replaced rsync with [openrsync](https://ss64.com/mac/openrsync.html), this is because Apple could not comply with the terms of GPLv3 license for current versions of rsync.

The pre-Sequoia Apple version of rsync does not perform as well as rsync 3.x, consumes more memory, and will copy unmodified resource forks.

To manually install a [GPLv3 version of rsync 3.x](https://ss64.com/bash/rsync.html) with [homebrew](https://ss64.com/mac/brew.html) use: brew install rsync

Syntax:
       rsync [_options_] _Source_ [_Source..._] _Destination_

Quick basic example: backup the desktop to the mybackups folder on an external hard drive:

   rsync -rlpt --stats  Desktop /volumes/LaCieDrive/mybackups

   Options used above:
     -r = Recursive, traverse into subdirectories
     -l = Treat symlinks as symlinks; don’t follow them
     -p = Preserve permissions
     -t = Preserve creation and modification dates and times
     --stats = Show file transfer statistics

**Options**

_What to copy:_

     --exclude=_PATTERN_       Exclude files matching _PATTERN_
     --exclude-from=_FILE_     Exclude patterns listed in _FILE_
 -E, --extended-attributes   Copy extended attributes ([xattr](https://ss64.com/mac/xattr.html))
     --files-from=_FILE_       Read list of source-file names from _FILE_
 -f, --filter=_RULE_           add a file-filtering _RULE_
 -F                          same as --filter='dir-merge /.rsync-filter'
                             repeated: --filter='- .rsync-filter'
 -I, --ignore-times          Don’t exclude files that match length and time
     --size-only             Only use file size when determining if a file should be transferred

     --include=_PATTERN_       Don’t exclude files matching _PATTERN_
     --include-from=_FILE_     Don’t exclude patterns listed in _FILE_
     --max-size=_SIZE_         Don’t transfer any file larger than _SIZE_
     --min-size=_SIZE_         Don’t transfer any file smaller than _SIZE_
     --modify-window=_NUM_     Timestamp window (seconds) for file match (default=0)
 -m, --prune-empty-dirs      prune empty directory chains from the file-list
     --modify-window=NUM     Compare mod-times with reduced accuracy
 -p, --perms                 Preserve permissions
     --specials              Preserve special files
 **-r, --recursive**             Recursive, traverse into subdirectories
 -R, --relative              Use relative path names
     --no-implied-dirs       Don’t send implied dirs with --relative
     --size-only             Skip files that match in size

_How to copy it:_

 -e, --rsh=_COMMAND_           Specify rsh replacement
     --rsync-path=_PATH_       Specify path to rsync on the remote machine
     --chmod=_CHMOD_           Affect file and/or directory permissions
 -d, --dirs                  Transfer directories without recursing
 -D, --devices               Preserve devices (root only)
     --executability         Preserve the file’s executability
 -g, --group                 Preserve group
 -H, --hard-links            Preserve hard links
 -l, --links                 Treat symlinks as symlinks; don’t follow them
 -L, --copy-links            Copy the referent of symlinks
     --copy-unsafe-links     Copy links outside the source tree
     --safe-links            Ignore links outside the destination tree
 -n, --dry-run               Show what would have been transferred
     --numeric-ids           Don’t map uid/gid values by user/group name
 -o, --owner                 Preserve owner (root only)
 -O, --omit-dir-times        Omit directories when preserving times
     --partial               Keep partially transferred files
     --partial-dir=_DIR_       Put a partially transferred file into _DIR_
     --delay-updates         Put all updated files into place at transfer’s end

 -t, --times                 Preserve creation and modification dates and times
     --timeout=_TIME_          Set IO timeout in seconds
 -S, --sparse                Handle sparse files efficiently
 -W, --whole-file            Copy whole files, no incremental checks
 -x, --one-file-system       Don’t cross filesystem boundaries

_Destination options:

_ -a, --archive               Archive mode
 -b, --backup                Make backups (default ~ suffix)
     --backup-dir=_DIR_        Make backups into this directory
     --suffix=_SUFFIX_         Override backup suffix
 -c, --checksum              Always checksum
 -C, --cvs-exclude           Auto ignore files in the same way CVS does
     --existing              Only update files that already exist
     --ignore-existing       skip updating files that already exist on receiver

     --del                   Delete files that don’t exist on the sending side
     --delete                an alias for --delete-during
     --delete-after          Delete after transferring, not before
     --delete-before         receiver deletes before transfer (default)
     --delete-during         receiver deletes during transfer, not before
     --delete-excluded       Also delete excluded files on the receiving side

     --force                 Force deletion of directories even if not empty
     --ignore-errors         Delete even if there are IO errors
     --max-delete=_NUM_        Don’t delete more than NUM files
     --list-only             List the files instead of copying them
     --log-format=_FORMAT_     Log file transfers using specified format
     --partial               Keep partially transferred files
     --progress              Show progress during transfer
 -P                          Equivalent to --partial --progress
     --stats                 Show file transfer statistics
     --remove-source-files   Sender removes synchronized files (non-dirs)
 -T  --temp-dir=DIR          create temporary files in directory DIR
     --compare-dest=DIR      Also compare destination files relative to DIR
 -u, --update                Update only (don’t overwrite newer files)
     --inplace               Update destination files in-place (SEE MAN PAGE)
     --append                Append data onto shorter files.
 -z, --compress              Compress file data
     --compress-level=_NUM_    Explicitly set compression level

_Misc Others:_

 -0, --from0                 All *-from/filter files are delimited by 0s
 -4, --ipv4                  Prefer IPv4
 -6, --ipv6                  Prefer IPv6
 -8, --8-bit-output          Leave high-bit chars unescaped in output
     --address=_ADDRESS_       Bind address for outgoing socket to daemon
 -B, --block-size=_SIZE_       Force a fixed checksum block-size
     --blocking-io           Use blocking IO for the remote shell
     --bwlimit=_KBPS_          Limit I/O bandwidth, KBytes per second
     --cache                 Disable fcntl(F_NOCACHE)
     --config=_FILE_           Specify alternate rsyncd.conf file
     --daemon                Run as a rsync daemon
 -f, --read-batch=_FILE_       Read batch file
 -F, --write-batch           Write batch file
 -h, --help                  Show help (with no other options)
 -h, --human-readable        Output numbers in a human-readable format
 -i, --itemize-changes       output a change-summary for all updates
 -k, --copy-dirlinks         Transform symlink to a dir into referent dir
 -K, --keep-dirlinks         Treat symlinked dir on receiver as dir
     --out-format=_FORMAT_     output updates using the specified _FORMAT_
     --log-file=_FILE_         log what we’re doing to the specified _FILE_
     --log-file-format=_FMT_   log updates using the specified _FMT_
     --no-detach             Do not detach from the parent
     --password-file=_FILE_    Get password from _FILE_
     --port=_PORT_             Specify alternate rsyncd port number
     --protocol=_NUM_          Force an older protocol version to be used
     --sockopts=_OPTIONS_      Specify custom TCP options
     --stats                 Give some file-transfer stats
     --super                 Receiver attempts super-user activities
 -T, --temp-dir=_DIR_          Create temporary files in directory _DIR_
 -v, --verbose               Increase verbosity
 -q, --quiet                 Decrease verbosity
     --version               Print version number
     --write-batch=_FILE_      Write a batched update to _FILE_
     --only-write-batch=_FILE_ Like --write-batch but w/o updating destination
     --read-batch=_FILE_       Read a batched update from _FILE_
 -y, --fuzzy                 Find similar file for basis if no dest file
     --compare-dest=_DIR_      Also compare destination files relative to _DIR_
     --copy-dest=_DIR_         ... and include copies of unchanged files
     --link-dest=_DIR_         Hardlink to files in _DIR_ when unchanged

Additional details about the options above can be found on the [rsync options and Exit Values](https://ss64.com/mac/rsync_options.html) page.

In many cases the Source and Destination will be a directory path, however _either_ the Source or the Destination can be on a remote host:

       [_User_@]_Host_:_Source_or_Destination_directory_

       [_User_@]_Host_::_Source_or_Destination_directory_

       rsync://[_User_@]_Host_[:_Port_]/_Source_or_Destination_directory_

## Description

> rsync is a program that behaves in much the same way that [rcp](https://ss64.com/mac/rcp.html) does, but has many more options and uses the rsync remote-update protocol to greatly speed up file transfers when the destination file already exists.  
>   
> The rsync remote-update protocol allows rsync to transfer just the differences between two sets of files across the network link, using an efficient checksum-search algorithm described in the technical report that accompanies this package.
> 
> Some of the additional features of rsync are:  
>   
> # support for copying links, devices, owners, groups and permissions  
> # exclude and exclude-from options are similar to GNU tar  
> # a CVS exclude mode for ignoring the same files that CVS would ignore  
> # can use any transparent remote shell, including rsh or ssh  
> # does not require root privileges  
> # pipelining of file transfers to minimize latency costs  
> # support for anonymous or authenticated rsync servers (ideal for mirroring)

## General

> There are six different ways of using rsync. They are:  
>   
> # for copying local files. This is invoked when neither source nor destination path contains a : separator  
>   
> # for copying from the local machine to a remote machine using a remote shell program as the transport (such as rsh or ssh).  
> This is invoked when the destination path contains a single : separator.  
>   
> # for copying from a remote machine to the local machine using a remote shell program. This is invoked when the source contains a : separator.  
>   
> # for copying from a remote rsync server to the local machine. This is invoked when the source path contains a :: separator or a rsync:// URL.  
>   
> # for copying from the local machine to a remote rsync server. This is invoked when the destination path contains a :: separator.  
>   
> # for listing files on a remote machine. This is done the same way as rsync transfers except that you leave off the local destination.  
>   
> In all cases (other than listing) at least one of the _source_ and _destination_ paths must be local.

## Usage

> You use rsync in the same way you use rcp. You must specify a source and a destination, one of which can be remote.  
>   
> Perhaps the best way to explain the syntax is some examples:
> 
>    rsync *.c foo:Source/
> 
> This would transfer all files matching the pattern *.c from the current directory to the directory Source on the machine foo.  
> If any of the files already exist on the remote system then the rsync remote-update protocol is used to update the file by sending only the differences.  
> See the tech report for details.
> 
>    rsync -avz foo:Source/bar /data/tmp
> 
> this would recursively transfer all files from the directory Source/bar on the machine foo into the /data/tmp/bar directory on the local machine.  
> The files are transferred in "archive" mode, which ensures that symbolic links, devices, attributes, permissions, ownerships etc are preserved in the transfer. Additionally, compression will be used to reduce the size of data portions of the transfer.
> 
>    rsync -avz foo:Source/bar/ /data/tmp
> 
> a trailing slash on the source changes this behavior to transfer all files from the directory Source/bar on the machine foo into the /data/tmp/.  
> A trailing / on a source name means "copy the contents of this directory". Without a trailing slash it means "copy the directory".  
> This difference becomes particularly important when using the --delete option.  
>   
> You can also use rsync in local-only mode, where both the source and destination don’t have a ':' in the name. In this case it behaves like an improved copy command.
> 
>   rsync somehost.mydomain.com::
> 
> this would list all the anonymous rsync modules available on the host somehost.mydomain.com. (See the following section for more details.)

## Connecting to an Rsync Server

> It is also possible to use rsync without using rsh or ssh as the transport. In this case you will connect to a remote rsync server running on TCP port 873.  
>   
> You can establish the connection via a web proxy by setting the environment variable RSYNC_PROXY to a hostname:port pair pointing to your web proxy. Note that your web proxy’s configuration must allow proxying to port 873.  
>   
> Using rsync in this way is the same as using it with rsh or ssh except that:
> 
> - you use a double colon :: instead of a single colon to separate the hostname from the path.
> - the remote server might print a message of the day when you connect.
> - if you specify no path name on the remote server then the list of accessible paths on the server will be shown.
> - if you specify no local destination then a listing of the specified files on the remote server is provided.
> 
> Some paths on the remote server will require authentication. If so then you will receive a password prompt when you connect.  
> You can avoid the password prompt by setting the environment variable RSYNC_PASSWORD to the password you want to use or using the --password-file option. This may be useful when scripting rsync.  
>   
> WARNING: On some systems environment variables are visible to all users. On those systems using --password-file is recommended.

## Running an Rsync Server

> An rsync server is configured using a config file which by default is  
> called /etc/rsyncd.conf. Please see the rsyncd.conf(5) man page for more information.

## Exclude Patterns

> The exclude and include patterns specified to rsync allow for flexible selection of which files to transfer and which files to skip.  
>   
> rsync builds an ordered list of include/exclude options as specified on the command line. When a filename is encountered, rsync checks the name against each exclude/include pattern in turn. The first matching pattern is acted on.  
> If it is an exclude pattern, then that file is skipped.  
> If it is an include pattern then that filename is not skipped.  
> If no matching include/exclude pattern is found then the filename is not skipped.  
>   
> Note that when used with -r (which is implied by -a), every subcomponent of every path is visited from top down, so include/exclude patterns get applied  
> recursively to each subcomponent.  
>   
> Note also that the --include and --exclude options take one pattern each. To add multiple patterns use the --include-from and --exclude-from options  
> or multiple --include and --exclude options.  
>   
> The patterns can take several forms. The rules are:
> 
> - if the pattern starts with a / then it is matched against the start of the filename, otherwise it is matched against the end of the filename. Thus "/foo" would match a file called "foo" at the base of the tree. On the other hand, "foo" would match any file called "foo" anywhere in the tree  
>     because the algorithm is applied recursively from top down; it behaves as if each path component gets a turn at being the end of the file name.
> - if the pattern ends with a / then it will only match a directory, not a file, link or device.
> - if the pattern contains a wildcard character from the set *?[ then expression matching is applied using the shell filename matching rules. Otherwise a simple string match is used.
> - if the pattern includes a double asterisk "**" then all wildcards in the pattern will match slashes, otherwise they will stop at slashes.
> - if the pattern contains a / (not counting a trailing /) then it is matched against the full filename, including any leading directory.  
>     If the pattern doesn’t contain a / then it is matched only against the final component of the filename. Again, remember that the algorithm is applied recursively so "full filename" can actually be any portion of a path.
> - if the pattern starts with "+ " (a plus followed by a space) then it is always considered an include pattern, even if specified as part of an exclude option.  
>     The "+ " part is discarded before matching.
> - if the pattern starts with "- " (a minus followed by a space) then it is always considered an exclude pattern, even if specified as part of an include option. The "- " part is discarded before matching.
> - if the pattern is a single exclamation mark ! then the current include/exclude list is reset, removing all previously defined patterns.
> 
> The +/- rules are most useful in exclude lists, allowing you to have a single exclude list that contains both include and exclude options.  
>   
> If you end an exclude list with --exclude '*', note that since the algorithm is applied recursively that unless you explicitly include parent directories of files  
> you want to include then the algorithm will stop at the parent directories and never see the files below them.  
> To include all directories, use --include '*/' before the --exclude '*'.  
>   
> Here are some exclude/include examples:  
>   
> # --exclude "*.o" would exclude all filenames matching *.o  
> # --exclude "/foo" would exclude a file in the base directory called foo  
> # --exclude "foo/" would exclude any directory called foo.  
> # --exclude "/foo/*/bar" would exclude any file called bar two levels below a base directory called foo.  
> # --exclude "/foo/**/bar" would exclude any file called bar two or more levels below a base directory called foo.  
> # --include "*/" --include "*.c" --exclude "*" would include all directories and C source files  
> # --include "foo/" --include "foo/bar.c" --exclude "*"  
> would include only foo/bar.c (the foo/ directory must be explicitly included or it would be excluded by the "*")

## Bitrot

> Backup files that are suffering from [SSD bitrot](https://rachelbythebay.com/w/2025/05/31/sync/) may have identical mtimes and identical sizes. The only way to be sure you have a valid copy is to compare the file hashes, which is a much slower process.
> 
> rsync has both -I (ignore-times) and -c (Skip copy only if checksums don't match) which do not use a quick check and instead will run a checksum on the files.

## Batch Mode

> The following call generates 4 files that encapsulate the information for synchronizing the contents of target_dir with the updates found in Source_dir  
>   
> $ rsync -F [other rsync options here] \ /somewhere/Source_dir /somewhere/target_dir  
>   
> The generated files are labeled with a common timestamp:  
>   
> # rsync_argvs._timestamp_ command-line arguments  
> # rsync_flist._timestamp_ rsync internal file metadata  
> # rsync_csums._timestamp_ rsync checksums  
> # rsync_delta._timestamp_ data blocks for file update & change

## Symbolic Links

> Three basic behaviors are possible when rsync encounters a symbolic link in the source directory.  
>   
> By default, symbolic links are not transferred at all. A message "skipping non-regular" file is emitted for any symlinks that exist.  
>   
> If --links is specified, then symlinks are recreated with the same target on the destination. Note that --archive implies --links.  
>   
> If --copy-links is specified, then symlinks are "collapsed" by copying their referent, rather than the symlink.  
>   
> rsync also distinguishes "safe" and "unsafe" symbolic links.  
> An example where this might be used is a web site mirror that wishes ensure the rsync module they copy does not include symbolic links to /etc/passwd in the public section of the site. Using --copy-unsafe-links will cause any links to be copied as the file they point to on the destination.  
> Using --safe-links will cause unsafe links to be ommitted altogether.

## Diagnostics

> rsync occasionally produces error messages that may seem a little cryptic.  
> The one that seems to cause the most confusion is "protocol version mismatch - is your shell clean?".  
>   
> This message is usually caused by your startup scripts or remote shell facility producing unwanted garbage on the stream that rsync is using for its transport. The way to diagnose this problem is to run your remote shell like this:
> 
>    rsh remotehost /bin/true > out.dat
> 
> Then look at out.dat. If everything is working correctly then out.dat should be a zero length file. If you are getting the above error from rsync then you will  
> probably find that out.dat contains some text or data. Look at the contents and try to work out what is producing it.  
> The most common cause is incorrectly configured shell startup scripts (such as .cshrc or .profile) that contain output statements for non-interactive logins.  
>   
> If you are having trouble debugging include and exclude patterns, then try specifying the -vv option. At this level of verbosity rsync will show why each individual file is included or excluded.

## Setup

> See the file README for installation instructions.  
>   
> Once installed you can use rsync to any machine that you can use rsh to. rsync uses rsh for its communications, unless both the source and destination are local.  
>   
> You can also specify an alternative to rsh, either by using the -e command line option, or by setting the RSYNC_RSH environment variable.  
>   
> One common substitute is to use ssh, which offers a high degree of security. Note that rsync must be installed on both the source and destination machines.

## Environment Variables

> CVSIGNORE
>     The CVSIGNORE environment variable supplements any ignore patterns in .cvsignore files.
>     See the --cvs-exclude option for more details.
> 
> RSYNC_RSH
>     The RSYNC_RSH environment variable allows you to override the default shell used as
>     the transport for rsync. This can be used instead of the -e option.
> 
> RSYNC_PROXY
>     The RSYNC_PROXY environment variable allows you to redirect your rsync client to
>     use a web proxy when connecting to a rsync daemon.
>     You should set RSYNC_PROXY to a hostname:port pair.
> 
> RSYNC_PASSWORD
>     Setting RSYNC_PASSWORD to the required password allows you to run authenticated
>     rsync connections to a rsync daemon without user intervention.
>     Note that this does not supply a password to a shell transport such as ssh.
> 
> USER or LOGNAME
>     The USER or LOGNAME environment variables are used to determine the default
>     username sent to a rsync server.
> 
> HOME
>     The HOME environment variable is used to find the user's default .cvsignore file.

## FILES

> /etc/rsyncd.conf

### Examples

To backup the home directory using a cron job:

   rsync -Cavz . server64:backup

> Run the above over a PPP link to a duplicate directory on machine "server64".

To synchronize samba source trees use the following Makefile targets:

> get:  
> rsync -avuzb --exclude '*~' samba:samba/ .
> 
> put:  
> rsync -Cavuzb . samba:samba/
> 
> sync:  
> get put
> 
> This allows me to sync with a CVS directory at the other end of the link. I then do cvs operations on the remote machine, which saves a lot of time as the remote cvs protocol isn’t very efficient.

I mirror a directory between my "old" and "new" ftp sites with the command:

   rsync -az -e ssh --delete ~ftp/pub/samba/ nimbus:"~ftp/pub/tridge/samba"

> This is launched from cron every few hours.

“I was the only kid in the audience who didn’t understand why Dorothy would ever want to go home. It was a mystery to me. To that awful black and white farm, with that aunt who was dressed badly, with smelly farm animals around. When she could live with winged monkeys and magic shoes and gay lions. I didn’t get it” ~ John Waters

### Related macOS commands

Local man page: [rsync](x-man-page://rsync) - Command line help page on your local machine.  
[rsync.samba.org](https://rsync.samba.org/) - Download latest version (plus docs).  
[cp](https://ss64.com/mac/cp.html) - Copy files.  
[install](https://ss64.com/mac/install.html) - Copy files and set attributes.  
[rcp](https://ss64.com/mac/rcp.html) - Remote file copy.  
[rsnapshot](https://rsnapshot.org/) - Save multiple backups with rsync.  
[Grsync](https://www.opbyte.it/grsync/) - GUI for rsync.  
[youtube-dl](https://ss64.com/tools/yt-dlp.html) - Download video.