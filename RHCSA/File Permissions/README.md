# File Permissions

## Basic File Permissions

**chmod** is the command used to change permissions on a file or directory. The
 **-R** switch can be used to apply the permissions recursively to all content
 inside a directory.

Permissions   | On a File                                 | On a Directory
------------- | ----------------------------------------- | -----------------------------------------------------
read (r/4)    | Permission to read the file.              | Permission to list the contents of the directory.
write (w/2)   | Permission to write (change) the file.    | Permission to create and remove files in a directory.
execute (x/1) | Permission to run the files as a program. | Permission to access the files in the directory.

### Symbolic Method

```
chmod WhoWhatWhich file|directory.
```

* _Who_ is u, g, o, a (for user, group, other, all).
* _What_ is +, -, = (for add, remove, set exactly).
* _Which_ is r, w, x (for read, write, execute).

#### Examples

Remove read and write permission for group and other on file1:
```
chmod go-rw file1
```

Add execute permission for everyone on file2:
```
chmod a+w file2
```

### Numeric Method

```
chmod ### file|directory
```

* Each digit represents an access level: user, group, other.
* # is the sum of r=4, w=2, and x=1.

#### Examples

Set read, write, and execute permission for user, read, and execute for group,
 and no permission for other on sampledir:

```
chmod 750 sampledir
```

### Special Permissions

The **setuid** and **setgid** permission on an executable file means that the 
 command will run as the user, or group, of the file, not as the user that ran 
 the command. The **setgid** permission on a directory means that files created 
 in that directory will be given the same group ownership as that directory. 
 This permission can be spotted in a long listing of a file or directory. A 
 lowercase **s** will appear where an **x** would normally appear for either 
 the user or group permission. If the owner does not have execute permissions, 
 this will be replaced by an uppercase **S**.

The **sticky bit** permission on a directory means files in that directory can 
 only be renamed or deleted by their owners. This can be spotted on a long
 listing by a lowercase **t** where an **x** would normally appear for the
 other permission. If the other does not have execute permissions, this will be
 replaced by an uppercase **T**.

* Symbolically: setuid=u+s, setgid=g+s, sticky=o+t
* Numerically (fourth digit): setuid=4, setgid=2, sticky=1

#### Examples

Add the setuid bit on file1:
```
chmod u+s file1
chmod 7554 file1
```

Add the setguid bit on dir1:
```
chmod g+s dir1
chmod 7542 dir1
```

Add the sticky bit on dir1:
```
chmod o+t dir1
chmod 7541 dir1
```

## Basic File Ownership

**chown** is the command used to change owners and groups. The **-R** switch can be used to 
 apply the permissions recursively to all content inside a directory.

```
chown user:group file|directory
```

#### Examples

Grant ownership of file1 to student:
```
chown student file1
```

Grant ownership of dir1 to the user visitor and group guest:
```
chown visitor:guest dir1
```

Grant ownership of dir1 and all contents inside to the guest group:
```
chown -R :guest dir1
```

## Default File Permissions

The default permissions for files are set by the processes that create them. Text
 editors and shell redirection create files that are only readable and writable,
 but not executable. Binary executables are created executable by the compilers
 that create them. The **mkdir** command creates new directories with all
 permissions set: read, write, and execute.

The **umask** command without arguments will display the current value of the
 shell's umask. Every process has a umask, which is an octal bitmask that is
 used to clear the permissions of new files and directories. Running the
 **umask** command will return either ### or ####. With the four digits, the
 leading digit idicates the special permission. A umask of ```037``` clears the
 write and execute permission for groups and all permission for other.

## Access Control Lists (ACLs)

Normal permissions are restricted to file owner, membership of a single group,
 or everyone else. ACLs allow fine-grained permissions to be allocated to a file.
 Named users or named groups, as well as users and groups identified by a UID or
 GUID, can be granted permissions, in addition to the standard file owner, group
 owner, and other file permissions. The same permission flags apply: read (r),
 write (w), and execute (x).

### ACL Friendly Filesystem

ACLs are enabled by default on an XFS filesystem. On other filesystems created
 on older versions, ACL may not be enabled. To check if ACLs are enabled on a
 filesystem, assuming the filesystem is **/dev/sda1**, run ```tune2fs -l /dev/sda1```
 and look for **acl** on the **Default mount options** line.

If ACLs are not enabled, they can be temporarily enabled by remounting the
 partition with with the acl option.

```
mount -o remount -o acl /home
```

To make sure it's permanent, edit **/etc/fstab** and add the acl to the list of
 boot options, then remount the filesystem.

### Viewing ACL Permissions

View and interpret ACLs with **ls** and **getfacl**. If using long listing, a
 **+** at the end of the 10-character permission string indicates that there are
 ACL settings accociated. Interpret the user, group, and other **rwx** flags as:

* user: Shows the user ACL settings, which are the same as the standard user
 file settings.

* group: Shows the current ACL mask settings, not the group-owner settings.

* other: Shows the other ACL settings, which are the same as the standard other
 file settings.


**getfacl** returns a detailed list of permissions:

```
getfacl file1.txt
```

This returns the following output:

```
# file: file1.txt
# owner: admin1
# group: admins
user:: rwx
user:james:---
user:1005:rwx     #effective:rw-
group::rwx        #effective:rw-
group:sodor:r--
group:2210:rwx    #effective:rw-
mask::rw-
other::---
```

First three lines have the filename, owner, and group owner. If there are any
 additional file flags, for example setuid or setgid, then a fourth comment line
 will appear showing which flags are set.

The user entries will show different user permissions starting with the file
 owner represented by the doubl colon. The **#effective** flag shows what
 permissions are available based on the mask setting. The group entries along
 with other works the same way.

ACL settings on a directory will look a little different:

```
# file: dir1
# owner: admin1
# group: admins
user:: rwx
user:james:---
user:1005:rwx     #effective:rw-
group::rwx        #effective:rw-
group:sodor:r--
group:2210:rwx    #effective:rw-
mask::rw-
other::---
default:user::rwx
default:user:james:---
default:group::rwx
default:group:sodor:r-x
default:mask::rwx
default:other::---
```

The biggest difference is the default user, group, mask, and other settings. For
 the default users and groups entries, the read and write permissions get set on 
 new files and execute gets set on new directories. The default mask settings
 show the initial maximum permissions possible for all new files or directories
 created that have named user ACLs, group owner ACL, or named group ACLs.

### Creating ACL Permissions
