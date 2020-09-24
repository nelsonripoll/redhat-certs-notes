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

To change between virtual terminals, you press the __ALT+F*n*__ to move to the
 *n*th virtual terminal. For example, to swith to the 3rd virtual terminal, I
 would press **ALT+F3**. If I am using a GUI, I would need to use
 __ALT+CTRL+F*n*__ to move to the *n*th virtual terminal.

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

### cp

### mv

### rm

### mkdir

### rmdir

### vi


## Text Streams

### cat

### less & more

### head & tail

### sort

### grep

### sed

### awk


## Command Redirection

### <

### >

### |

### 2>

### &>
