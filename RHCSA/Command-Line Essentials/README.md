# Command-Line Essentials

## Shells

In Linux, the shell is a command-line interpreter that allows you to interact
 with the operating system. Shells can process commands in various sequences,
 depending on how you manage the input and output of each command. The way
 commands are interpreted is in part determined by variables and parameters
 associated with each shell.

Users can choose between multiple command-line shells:

+ bash - The Bourne-Again shell, this is the default shell based on the
 command-line interpreter originally developed by Stephen Bourne.
+ ksh - The Korn shell, developed by David Korn at Bell Labs in the 1980s,
 to incorporate the best features of the Bourne and C shell.
+ tcsh - An enhanced version of the Unix C shell.
+ zsh - A sophisticated shell, similar to the Korn shell.

These shells are located in the /bin directory. The most direct method to change
 a user's shell is to edit the /etc/passwd file. The other way is to use the 
 __chsh -s /bin/*shell* *username*__ command.

When running a command, the shell cites the full path to that command. For
 example, the __ls__ command is located in the /bin directory. When we run
 __ls__ the shell is actually running __/bin/ls__. This is where the PATH
 environment variable comes in.

The PATH variable is a colon seperated list of directories defined for the current user.
 These directories are searched, in order, for the command being used. You can
 view the PATH variable by running __echo $PATH__. The PATH variable is globally
 defined by the /etc/profile file or scripts in the /etc/profile.d directory.
 The PATH for individual users can be customized by modifying the .bash\_profile
 or .profile hidden files in the user's home directory.

The command line prompt differs between regular users and the root user. A 
 regular user's prompt by default is the username, hostname, and current directory
 followed by a __$__. The root prompt is similar but has a __#__ instead.

```
[user@localhost ~]$

[root@localhost ~]#
```

## Virtual Terminals

Virtual terminals is a conceptual combination of the keyboard and display for a 
 computer user interface. It is a feature in which the system console of the 
 computer can be used to switch between multiple virtual consoles to access
 independent login sessions.

Virtual terminals are defined by the /etc/systemd/logind.conf file. By default,
 a maximum of 6 virtual terminals can be activated and are associated with the
 device files /dev/tty1 through /dev/tty6. It's possible to configure more
 virtual terminals but is limited by those allowed for the root administrative
 user in the /etc/securetty file.

To change between virtual terminals, press the __ALT+F*n*__ to move to the
 *n*th virtual terminal. For example, to swith to the 3rd virtual terminal, press 
 **ALT+F3**. If using a GUI, use __ALT+CTRL+F*n*__ to move to the *n*th virtual 
 terminal.

## Navigation

Everything in Linux can be reduced to a file. Directories are special types
 of files that serve as containers for other files. To navigate and find
 files, you need some basic commands and concepts to tell you where you are
 and how to move from directory to directory.

The concept that describes where you are in the Linux directory tree is the path.
 There are two types of path concepts: absolute path and relative path. An
 absolute path always starts from the root (__/__) directory where a relative
 path starts from your current location.

Another concept to recognize is the tilde (__~__). The tilde represents the 
 current user's home directory.

The __pwd__ command identifies the current directory. For example, if the user
 is in the home directory:

```
[username@localhost ~]$ pwd
/home/username
```

The __ls__ command will list files and directories in your current location.
 To view files and directories in another location, simply provide the path as
 an argument to __ls__:

```
[username@localhost ~]$ ls /path/to/dir
file1   file2   file3    dir1    dir2
```

With the right switches, __ls__ can be a very powerful tool. The __-a__ switch
 will list hidden files. The __-l__ switch will do a long listing and provide
 extra information for each file and directory, like permissions and the 
 timestamp it was last modified. Perhaps the most useful switch is __-Z__, which
 will provide the SELinux contexts of the files and directories.

The __cd *path*__ command is used to change directories. By itself, __cd__ will take
 you to the current user's home directory. It is equivalant to using the tilde as 
 an argument. You can go up one directory using the *..* shortcut. For example, 
 if you are in your user's home directory, using __cd ..__ will take you up one 
 directory to /home. The __cd__ command takes either an absolute path or a relative 
 path as an argument.

## Locating Files & Directories

The __find__ command searches through directories and subdirectories for a file.
 The format of the command is __find__ *directory* *pattern*. If you do not
 specify a directory, it starts at the current directory. The most common
 option to use is the __-name__ option where it looks for filenames that matches
 a pattern. 
 
This will look for all files and directories within the /etc directory with the 
 pattern "httpd" in the name.

```
[root@localhost /]# find /etc -name "*httpd*"
/etc/systemd/system/multi-user.target.wants/httpd.service
/etc/sysconfig/httpd
/etc/logrotate.d/httpd
/etc/httpd
/etc/httpd/conf/httpd.conf
```

Sometimes __find__ could take a while, especially if it has to search the entire
 filesystem. The __locate__ command is instantaneous but the drawback is this
 command requires a database to be up to date. The database is updated once a
 day from the /etc/cron.daily/mlocate script. If you need an updated database
 now, you can use the **updatedb** command or execute the mlocate script early.

If you need to locate the binary, or executable, for a shell command, you can
 use the __which__ command. The __which__ command will search the __PATH__
 environment variable for the location of the command given.

```
[root@localhost /]# which ping
/usr/bin/ping
```

A similar command is __whereis__, which returns the binary location, source 
 and manual page files for the given command.

```
[root@localhost /]# whereis ping
ping: /usr/bin/ping /usr/share/man/man8/ping.8.gz
```

You can view a short description from a command's man page files by using the
 __whatis__ command.
 
```
[root@localhost /]# whatis ping
ping (8) - send ICMP ECHO_REQUEST to network hosts
```

## Manage Files & Directories

### touch

Change a file timestamps. If the file does not exist, it creates an empty file.

Switch | Description
------ | ----------------------------------------
-a     | Change only the access time.
-c     | Do not create any files.
-d     | Datetime to use instead of current time.
-m     | Change only the modification time.

### cp
Copy files and directorys

Switch | Description
------ | --------------------------------------------------------------------------
-f     | If an existing destination file cannot be opened, remove it and try again.
-i     | Interactive prompt before overwrite.
-r     | Copy directories recursively.
-Z     | Set SELinux security context of destination file to default type.

### mv

Move (rename) files and directories.

Switch | Description
------ | --------------------------------------------------------------------------
-f     | If an existing destination file cannot be opened, remove it and try again.
-i     | Interactive prompt before overwrite.
-u     | Move only when source file is newer than the destination file.
-Z     | Set SELinux security context of destination file to default type.

### mkdir

Make directories.

Switch | Description
------ | -----------------------------------------------------------------
-p     | Make parent directories as needed.
-Z     | Set SELinux security context of destination file to default type.

### rm

Remove files or directories.

Switch | Description
------ | --------------------------------------------------------------------------
-f     | If an existing destination file cannot be opened, remove it and try again.
-r     | Remove directories and their contents recursively.
-d     | Remove empty directories.
-i     | Interactive prompt before removal.

### rmdir

Remove empty directories.

Switch | Description
------ | -----------------------------------
-p     | Remove directory and its ancestors.

### nano

A console text editor.

TODO: requires documentation

### vim

A console text editor. Improved version of **vi**.

TODO: requires documentation

## Text Streams

### cat

Concatenate files and print on the standard output.

Switch | Description
------ | -------------------------------------------------------------------------
-n     | Number all output lines.
-T     | Display TAB characters as ^I

### less & more

Filter for paging through text one screenful at a time. **less** provides **more**
 emulation plus extensive enhancements.

Switch | Description
------ | ------------------------------------------------------------------------------------------------------
-f     | Count logical lines instead of screen lines.
-p     | Do not scroll, clear whole screen then display the text.
-c     | Do not scroll, paint each screen from the top, clearing the remainder of each line as it is displayed.
-s     | Squeeze multiple blank lines into one.

### head & tail

Output the first or last parts of files. **head** will print the first 10 lines
 while **tail** will print the last 10.

Switch | Description
------ | -----------------------------------------------------------
-n     | Print the first/last NUM lines instead of the first/last 10

### sort

Sort lines of a text file.

Switch | Description
------ | ----------------------------------
-r     | Reverse the result of comparisons.

### grep

The **grep** command uses a search term to look through a file. Regular expressions
 can be used, which provides a powerful way to specify complex search patterns.
 There are metacharacters to use that have special meanings, if they need to be
 literal then precede them with a backslash.

Metacharacter | Description
------------- | --------------------------------------------------------
.             | Any single character.
[]            | Match any single character included within the brackets.
?             | Match the preceding element zero or one times.
+             | Match the preceding element one or more times.
*             | Match the preceding element zero or more times.
^             | Match the beginning of a line.
$             | Match the end of a line.

Switch | Description
------ | ----------------------------------------------------------------------
-i     | Make the search case-insensitive.
-E     | Enables the use of extended regular expression syntax.
-v     | Reverses the matching. Returns lines that do not match the expression.
-e     | Allows the use of multiple search patterns.

### diff

Compare files line by line for differences.

Switch | Description
------ | -----------------------------------------
-i     | Ignore case differences in file contents.
-a     | Treat all files as text.
-w     | Ignore all white space.
-B     | Ignore changes where lines are all blank.

### wc

Print newline, word, and byte counts for each file, and a total line if more than
 one file is specified.

Switch | Description
------ | -----------------------------------------
-c     | Print the byte counts.
-m     | Print the character counts.
-l     | Print the line counts.
-w     | Print the word counts.

### sed & awk

**sed** is a stream editor for filtering and transforming text. **awk** is a
 pattern scanning and processing language.

TODO: requires documentation

## Networking

### ping

**ping** uses the ICMP protocol's mandatory ECHO_REQUEST datagram to elicit an 
 ICMP ECHO_RESPONSE from a host or gateway.

Switch | Description
------ | -----------------------------------------
-4     | Use IPv4 only.
-6     | Use IPv6 only.
-c     | Stop after sending after _count_ ECHO_REQUEST packets.
-i     | Wait _interval_ seconds between sending each packet.

### telnet

**telnet** is used to communicate with another host using the TELNET protocol.

### traceroute

**traceroute** tracks the route packets taken from an IP network on their way to 
 a given host.

### ss

**ss** is used to dump socket statistics.

### ip

Show / manipulate routing, network devices, interfaces and tunnels.

#### subcommands

##### ip address (addr)

The **ip address** command displays addresses and their properties, adds new 
 addresses and deletes old ones.

##### ip link

The **ip link** command manages virtual links.

### ssh

**ssh** (SSH client) is a program for logging into a remote machine and for 
 executing commands on a remote machine.

### nmap

Nmap (“Network Mapper”) is an open source tool for network exploration and security 
 auditing. Nmap uses raw IP packets in novel ways to determine what hosts are 
 available on the network, what services (application name and version) those hosts 
 are offering, what operating systems (and OS versions) they are running, what 
 type of packet filters/firewalls are in use, and dozens of other characteristics. 
 
### mutt

A small but very powerful text based program for reading and sending electronic 
 mail under unix operating systems, including support for color terminals, MIME, 
 OpenPGP, and a threaded sorting mode.

### lftp

**lftp** is a file transfer program that allows sophisticated FTP, HTTP and 
 other connections to other hosts. **lftp** can handle several file access methods 
 - FTP, FTPS, HTTP, HTTPS, HFTP, FISH, SFTP and file (HTTPS and FTPS are only 
 available when **lftp** is compiled with GNU TLS or OpenSSL library). Besides 
 FTP-like protocols, **lftp** has support for BitTorrent protocol as `torrent' 
 command. Seeding is also supported.

### curl

**curl** is  a tool to transfer data from or to a server, using one of the supported 
 protocols (DICT, FILE, FTP, FTPS, GOPHER, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, 
 POP3, POP3S, RTMP, RTSP, SCP, SFTP, SMB, SMBS, SMTP, SMTPS, TELNET and TFTP). 
 The command is designed to work without user interaction.
