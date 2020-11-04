# Creating and Mounting File Systems

## Mounting and Unmounting File Systems

The ```mount``` command allows the root user to manually mount a file system.
 The first argument of the ```mount``` command specifies the file system to 
 mount, expected in one of two different ways: a device file of the partition
 holding the file system (residing in **/dev**) or the __UUID__.  The second 
 argument specifies the target directory (_mount point_) where the file system 
 is made available after mounting it.

The ```blkid``` command gives an overview of existing partitions with a file
 system on them and the UUID of the file system, as well as the file system
 used to format the partition.

```
# blkid
/dev/sda1: LABEL="EFI" UUID="E8D0-7585" TYPE="vfat" PARTLABEL="EFI System Partition" PARTUUID="36b68824-1251-4554-996a-738449f455dd"
/dev/sda2: LABEL="BOOT" UUID="eaea5a13-7a94-4aff-b15e-ddc2a3c34a80" TYPE="ext4" PARTUUID="591c6a57-4549-45d4-9387-ee5181d13c74"
/dev/sda3: LABEL="CENTOS-8" UUID="8f4c9801-4e9f-4374-95b5-b567d02db3f6" TYPE="xfs" PARTUUID="bdc94f6a-18c1-4038-9172-c22e2414750b"
/dev/sda4: LABEL="SWAP" UUID="e7fc5fb1-8e97-4cbd-a012-1bdd22765d2b" TYPE="swap" PARTUUID="1cb551a6-6dfb-46fd-9ac9-5f7519f0afd3"
```

Mount by device file of the partition that holds the file system:

```
# mount /dev/vdb1 /mnt/mydata
```

Mount the file system by universal unique id, or the UUID, of the file system:

```
# mount UUID="11111111-2222-3333-4444-555555555555" /mnt/mydata
```

To unmount a file system, the ```umount``` command expects the mount point as
 an argument. Unmounting is not possible if the mount point is accessed by a
 process. For umount to be successful, the process needs to stop accessing the
 mount point.

The ```lsof``` command lists all open files and the process accessing them in
 the provided directory. It is useful to identify which processes currently
 prevent the file system from successful unmounting.

```
# cd /mnt/mydata
# umount /mnt/mydata
umount: /mnt/mydata: target is busy
# lsof /mnt/mydata
COMMAND   PID   USER    FD    TYPE  DEVICE    SIZE/OFF    NODE  NAME
bash      1593  root    cwd   DIR   253,2     6           128   /mnt/mydata
lsof      2532  root    cwd   DIR   253,2     19          128   /mnt/mydata
lsof      2532  root    cwd   DIR   253,2     19          128   /mnt/mydata
# cd /
# umount /mnt/mydata
```

Removeable media, such as USB flash devices and drives, get automatically
 mounted by the graphical desktop environment when plugged in. The mount point
 for the removable medium is **/run/media/USER/LABEL**. The USER is the user
 logged into the graphical environment. The LABEL is the name given to the
 file system when it was created.

## Adding Partitions, File Systems, and Persistent Mounts

Disk partitioning allows hard drives to be divided into multiple logical storage
 units referred to as partitions. This allows admins to use different partitions
 to perform different functions:

* Limit available space to applications or users.
* Allow multibooting of different operating systems from the same disk.
* Separate operating system and program files from user files.
* Create a separate area for OS virtual memory swapping.
* Limit disk space usage to improve performance of diagnostic tools and backup imaging.

### Creating GPT Disk Partitions

While GPT support has been added to ```fdisk```, it is still considere
 experimental, so use the ```gdisk``` family: ```gdisk```, ```sgdisk```, 
 ```cgdisk```.

Execute the ```gdisk``` command and specify the disk device name as an argument.
 This will start the ```gdisk``` command in interactive mode, and will present
 a command prompt. Request a new partition by entering **n** as the command.

```
# gdisk /dev/vdb
GPT fdisk (gdisk) version 0.8.6

Partition table scan:
  MBR: not present
  BSD: not present
  APM: not present
  GPT: not present

Creating new GPT entries:

Command (? for help): n
```

Specify the partition number. This partition number serves as the identification
 number of the partition on the disk for use in future partition operations.
 Then, specify the disk location that the new partition will start from. 
 ```gdisk``` allows for two different input types. The first input type is an 
 absolute disk sector number. The second input type indicates the partition's
 starting sector by its position relative to the first or last sector of the
 first contiguous block of free sectors on the disk. For example, **+512M**
 refers to a sector position that is 512 MiB after the beginning of the next
 group of contiguous available sectors. On the other hand, **-512M** denotes a
 sector positioned 512 MiB before the end of this group of contiguous sectors.

```
First sector (34-20971486, default = 2048) or {+-}size{KMGTP}: 2048
Last sector (2048-20971486, default 20971486) or {+-}size{KMGTP}: +512M
```

New partitions created by ```gdisk``` default to type _Linux_ file system. If a
 different partition type is desired, enter the corresponding hex code. To view
 a table of the hex codes, use the **L** command. 

```
Current type is 'Linux filesystem'

Hex code or GUID (L to show codes, Enter = 8300): 8e00
Changed type of partition to 'Linux LVM'

```

To print the partition table, use the **p** command. 

```
Command (? for help): p
Disk /dev/vdb: 20971520 sectors, 10.0 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): 22222222-4444-6666-8888-10101010101010
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 20971486
Partitions will be aligned on 2048-sector boundaries
Total free space is 19922877 sectors (9.5 GiB)

Number  Start (sector)    End (sector)    Size        Code    Name
1       2048              1050623         512.0 MiB   8E00    Linux LVM
```

To delete a partition, use the **d** command.

```
Command (? for help): d
Using 1
```

Use the **w** command to finalize the partition creation request by writing the 
 changes to the disk's partition table. Enter **y** when ```gdisk``` prompts 
 for a final confirmation. ```gdisk``` queses all partition table edits and only
 writes them to disk after the **w** command. If **w** is not executed, all
 requested changes to the partition table will be discarded.

```
Command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING PARTITIONS!!

Do you want to proceed? (Y/N): y
OK; writing new GUID partition table (GPT) to /dev/vdb.
The operation has completed successfully.
```

Use the **q** command to quit ```gdisk```.  After all changes are made, 
 initiate a kernel re-read of the new partition table.

```
# partprobe /dev/vdb
```

After a block device has been created, the next step is applying a file system
 format to it. A file system applies a structure to the block device so that
 data can be stored and retrieved from it. The ```mkfs``` command can be used
 to apply a file system to a block device. The ```mkfs``` defaults to the type
 **ext2** but you can specify a type with the **-t** flag.

```
# mkfs -t xfs /dev/vdb1
```

To make a file system be persistently mounted every time the system starts up, 
 a listing for the file system needs to be added to **/etc/fstab**. **/etc/fstab** 
 is a white space-delimited file with six fields per line. 

The first field specifies the device to be used. The **UUID** is preferable here
 because block device identifiers can change in certain scenarios.

The second field is the mount point where the device should be attached into the
 directory hierarchy.

The third field contains the file system type that has been applied to the block
 device.

The fourth field is the list of options that should be applied to the device
 when mounted to customize the behavior.

The fifth field is the dump flag. It is used with the ```dump``` command to make
 a backup of the contents of the device.

The sixth field is the fsck order. It is used to determine if the ```fsck``` 
 command should be run at boot time, in the event that the file system was not 
 unmounted cleanly. The value of the fsck order indicates the order in which 
 file systems should have ```fsck``` run on them if multiple file systems are
 required to be checked.
 
An incorrect entry in **/etc/fstab** may render the system unbootable. To verify
 that the entry is valid, unmount the new file system and use the ```mount```
 command with the **-a** flag, which reads the **/etc/fstab** to mount the file
 system back into place. Fix any errors before rebooting the machine.

## Managing Swap Space

A _swap space_ is an area of a disk which can be used with the Linux kernel
 memory management subsystem. Swap spaces are used to supplement the system RAM
 by holding inactive pages of memory. The combined system RAM plus swap spaces
 is called _virtual memory_.

When the memory usage on a system exceeds a defined limit, the kernel will
 reassign idle memory pages in the RAM to the swap area, and will reassign the 
 RAM page to be used by another process.

To create a swap partition, use a tool like ```gdisk``` to create a partition
 and assign it a Linux type of **8200** for swap. The ```mkswap``` command will
 be used to format the partition as swap.

Use the ```swapon``` command to activate a formatted swap space. Use the **-a**
 flag to activate all swap spaces listed in the **/etc/fstab**. Inside the fstab,
 the entry for swap should have the second and third field set to **swap**. The
 fifth and sixth field should be set to **0** because swap does not need backing
 up nor file system checking.

**/etc/fstab**
```
UUID=11111111-2222-3333-4444-555555555555   swap  swap  defaults  0 0
```


