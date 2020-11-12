# Service Management And Boot Troubleshooting

## System Processes

System Startup and server processes are managed by the _systemd System and Service
 Manager_. This program provides a method for activating system resources,
 server daemons, and other processes, both a boot time and on a running system.

_Daemons_ are processes that wait or run in the background performing various
 tasks. By convention, the names of many daemon programs end in the letter "d".

To listen for connections, a daemon uses a _socket_. This is the primary
 communication channel with local or remote clients.

_Services_ often refers to one or more daemons, but starting or stopping a
 service may instead make a one-time change to the state of the system, which
 does not involve leaving a daemon process running afterward (called **oneshot**).

Process ID 1 is **systemd**, the init system. A few features provided by systemd
 include:

* Parallelization capabilities, which increase the boot speed of a system.
* On-demand starting of daemons without requiring a separate service.
* Automatic service dependency management, which can prevent long timeouts, such
 as by not starting a network service when the network is not available.
* A method of tracking related processes together by using Linux control groups.

The ```systemctl``` command is used to manage different types of systemd objects,
 called _units_. A list of available unit types can be displayed with
 ```systemctl -t help```.

Some common unit types are listed below:

* Service units have a .service extension and represent system services. This
 type of unit is used to start frequently accessed daemons, such as a web server.

* Socket units have a .socket extension and represent inter-process communication
 (IPC) sockets. Control of the socket will be passed to a daemon or newly started
 service when a client connection is made. Socket units are used to delay the
 start of a service at boot time and to start less frequently used services on
 demand.

* Path units have a .path extension and are used to delay the activation of a
 service until a specific file system change occurs. This is commonly used for
 services which use spool directories, such as a printing system.

The status of a service can be viewed with ```systemctl status name.type```. If
 the unit type is not provided, **systemctl** will show the status of a service
 unit, if one exists.

Several keywords indicating the state of the service can be found in the status
 output:

Keyword          | Description
---------------- | ------------
loaded           | Unit configuration file has been processed.
active (running) | Running with one or more continuing processes.
active (exited)  | Successfully completed a one-time configuration.
active (waiting) | Running but waiting for an event.
inactive         | Not running.
enabled          | Will be started at boot time.
disabled         | Will not be started at boot time.
static           | Can not be enabled, but may be started by an enabled unit automatically.

Query the state of all units to verify a system startup:

```
# systemctl
```

Query the state of only the service units:

```
# systemctl --type=service
```

Investigate any units which are in a failed or maintenance state:

```
# systemctl status rngd.service
```

Check to see if a unit is active and enabled at bootup:

```
# systemctl is-active sshd
# systemctl is-enabled sshd
```

List the active state of all loaded units, use **--all** option to add inactive 
 units:

```
# systemctl list-units --type=service
# systemctl list-units --type=service --all
```

View the enabled and disabled settings for all units, use **--type** to limit
 the type of unit:

```
# systemctl list-unit-files --type=service
```

View only failed services:

```
# systemctl --failed --type=service
```

## Controlling System Services

View the status of a service:

```
# systemctl status sshd.service
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Mon 2020-10-26 07:38:54 CDT; 1 weeks 4 days ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 1018 (sshd)
    Tasks: 1 (limit: 48532)
   Memory: 2.5M
   CGroup: /system.slice/sshd.service
           └─1018 /usr/sbin/sshd -D -oLISTOFOPTIONS

Oct 26 07:38:54 localhost.localdomain systemd[1]: Starting OpenSSH server daemon...
Oct 26 07:38:54 localhost.localdomain sshd[1018]: Server listening on 0.0.0.0 port 22.
Oct 26 07:38:54 localhost.localdomain sshd[1018]: Server listening on :: port 22.
Oct 26 07:38:54 localhost.localdomain systemd[1]: Started OpenSSH server daemon.
```

Verify that the process is running:

```
# ps -up PID
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root        1018  0.0  0.0  92968  7200 ?        Ss   Oct26   0:00 /usr/sbin/sshd -D -oLISTOFOPTIONS
```

Stop the service and verify the status:

```
# systemctl stop sshd.service
# systemctl status sshd.service
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: inactive (dead) since Fri 2020-11-06 13:14:15 CST; 4s ago
     Docs: man:sshd(8)
           man:sshd_config(5)
  Process: 1018 ExecStart=/usr/sbin/sshd -D $OPTIONS $CRYPTO_POLICY (code=exited, status=0/SUCCESS)
 Main PID: 1018 (code=exited, status=0/SUCCESS)

Oct 26 07:38:54 localhost.localdomain systemd[1]: Starting OpenSSH server daemon...
Oct 26 07:38:54 localhost.localdomain sshd[1018]: Server listening on 0.0.0.0 port 22.
Oct 26 07:38:54 localhost.localdomain sshd[1018]: Server listening on :: port 22.
Oct 26 07:38:54 localhost.localdomain systemd[1]: Started OpenSSH server daemon.
Nov 06 13:14:15 localhost.localdomain systemd[1]: Stopping OpenSSH server daemon...
Nov 06 13:14:15 localhost.localdomain sshd[1018]: Received signal 15; terminating.
Nov 06 13:14:15 localhost.localdomain systemd[1]: Stopped OpenSSH server daemon.
```

Start the service and view the status, the process ID has changed:

```
# systemctl start sshd.service
# systemctl status sshd.service
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2020-11-06 13:14:29 CST; 7s ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 183729 (sshd)
    Tasks: 1 (limit: 48532)
   Memory: 1.2M
   CGroup: /system.slice/sshd.service
           └─183729 /usr/sbin/sshd -D -oLISTOFOPTIONS
Nov 06 13:14:29 localhost.localdomain systemd[1]: Starting OpenSSH server daemon...
Nov 06 13:14:29 localhost.localdomain sshd[183729]: Server listening on 0.0.0.0 port 22.
Nov 06 13:14:29 localhost.localdomain sshd[183729]: Server listening on :: port 22.
Nov 06 13:14:29 localhost.localdomain systemd[1]: Started OpenSSH server daemon.
```

Stop, then start, the service in a single command:

```
# systemctl restart sshd.service
# systemctl status sshd.service
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2020-11-06 13:14:29 CST; 34s ago
     Docs: man:sshd(8)
           man:sshd_config(5)
  Process: 183733 ExecReload=/bin/kill -HUP $MAINPID (code=exited, status=0/SUCCESS)
 Main PID: 183729 (sshd)
    Tasks: 1 (limit: 48532)
   Memory: 1.4M
   CGroup: /system.slice/sshd.service
           └─183729 /usr/sbin/sshd -D -oLISTOFOPTIONS
Nov 06 13:14:29 localhost.localdomain systemd[1]: Starting OpenSSH server daemon...
Nov 06 13:14:29 localhost.localdomain sshd[183729]: Server listening on 0.0.0.0 port 22.
Nov 06 13:14:29 localhost.localdomain sshd[183729]: Server listening on :: port 22.
Nov 06 13:14:29 localhost.localdomain systemd[1]: Started OpenSSH server daemon.
Nov 06 13:14:49 localhost.localdomain systemd[1]: Reloading OpenSSH server daemon.
Nov 06 13:14:49 localhost.localdomain sshd[183729]: Received SIGHUP; restarting.
Nov 06 13:14:49 localhost.localdomain systemd[1]: Reloaded OpenSSH server daemon.
Nov 06 13:14:49 localhost.localdomain sshd[183729]: Server listening on 0.0.0.0 port 22.
Nov 06 13:14:49 localhost.localdomain sshd[183729]: Server listening on :: port 22.
```

Issue instructions for a service to read and reload its configuration file
 without a complete stop and start, the process ID will not change:

```
# systemctl reload sshd.service
# systemctl status sshd.service
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2020-11-06 13:14:29 CST; 7min ago
     Docs: man:sshd(8)
           man:sshd_config(5)
  Process: 183888 ExecReload=/bin/kill -HUP $MAINPID (code=exited, status=0/SUCCESS)
 Main PID: 183729 (sshd)
    Tasks: 1 (limit: 48532)
   Memory: 1.7M
   CGroup: /system.slice/sshd.service
           └─183729 /usr/sbin/sshd -D -oLISTOFOPTIONS

Nov 06 13:14:49 localhost.localdomain systemd[1]: Reloading OpenSSH server daemon.
Nov 06 13:14:49 localhost.localdomain sshd[183729]: Received SIGHUP; restarting.
Nov 06 13:14:49 localhost.localdomain systemd[1]: Reloaded OpenSSH server daemon.
Nov 06 13:14:49 localhost.localdomain sshd[183729]: Server listening on 0.0.0.0 port 22.
Nov 06 13:14:49 localhost.localdomain sshd[183729]: Server listening on :: port 22.
Nov 06 13:21:58 localhost.localdomain systemd[1]: Reloading OpenSSH server daemon.
Nov 06 13:21:58 localhost.localdomain sshd[183729]: Received SIGHUP; restarting.
Nov 06 13:21:58 localhost.localdomain systemd[1]: Reloaded OpenSSH server daemon.
Nov 06 13:21:58 localhost.localdomain sshd[183729]: Server listening on 0.0.0.0 port 22.
Nov 06 13:21:58 localhost.localdomain sshd[183729]: Server listening on :: port 22.
```

Services may be started as dependencies of other services. If a socket unit is
 enabled and the service unit with the same name is not, the service will
 automatically be started when a request is made on the network socket. Services
 may also be triggered by path units when a file system condition is met. For
 example, a file placed into the print spool directory will cause the **cups**
 print service to be started if it is not running.

To completely stop printing services on a system, stop all units. Disabling the 
 service will disable the dependencies.

The ```systemctl list-dependencies UNIT``` command can be used to print out a
 tree of what other units must be started if the specified unit is started.
 Depending on the exact dependency, the other unit may need to be running
 before or after the specified unit starts. The **--reverse** option to this
 command will show what units need to have the specified unit started in order
 to run.

At times, a system may have conflicting services installed. To prevent a service
 from accidentally starting, it can be _masked_. Masking will create a link in
 the configuration directories so that if the service is started, nothing will
 happen.

```
# systemctl mask cups.service
Created symlink /etc/systemd/system/cups.service → /dev/null.
# systemctl unmask cups.service
Removed /etc/systemd/system/cups.service.
```

Command                          | Task
-------------------------------- | ----
systemctl status UNIT            | View detailed information about a unit state.
systemctl stop UNIT              | Stop a service on a running system.
systemctl start UNIT             | Start a service on a running system.
systemctl restart UNIT           | Restart a service on a running system.
systemctl reload UNIT            | Reload a configuration file of a running system.
systemctl mask UNIT              | Completely disable a service from being started, both manually and at boot.
systemctl unmask UNIT            | Make a masked service available.
systemctl enable UNIT            | Configure a service to start at boot time.
systemctl disable UNIT           | Disable a service from starting at boot time.
systemctl list-dependencies UNIT | List units which are required and wanted by the specified unit.

## The Red Hat Enterprise Boot Process

This is a high-level overview of the tasks involved for a physical **x86_64**
 system booting Red Hat Enterprise Linux 7. The list for virtual machines is
 roughly the same, but some of the hardware-specific steps are handled in
 software by the _hypervisor_.

1. The machine is powered on. The system firmware (UEFI) runs a POST, and starts
 to initialize some of the hardware.

2. The system firmware searches for a bootable device, configured in the UEFI
 boot firmware.

3. The system firmware reads a _boot loader_ from disk, then passes control of
 the system to the boot loader (e.g., **grub2**).

4. The boot loader loads its configuration from disk, and presents the user with
 a menu of possible configurations to boot from.

5. The boot loader loads the configured kernel and _initramfs_ from disk and
 places them in memory. An **initramfs** is a **gzip**-ed **cpio** archive
 containing kernel modules for all hardware necessary at boot, init scripts,
 and more.

6. The boot loader hands control of the system over to the kernel, passing in
 any options specified on the kernel command line in the boot loader, and
 location of the **initramfs** in memory.

7. The kernel initializes all hardware for which it can find a driver in the
 **initramfs**, then executes **/sbin/init** from the **initramfs** as **PID 1**.

8. The **systemd** instance from the **initramfs** executes all units for the
 **initrd.target** target. This includes mounting the actual root file system
 on **/sysroot**.

9. The kernel root file system is switched from the **initramfs** root file
 system to the system root file system that was previously mounted on 
 **/sysroot.systemd** then re-executes itself using the copy of **systemd**
 installed on the system.

10. **systemd** looks for a default target, either passed in from the kernel 
 command line or configured on the system, then starts (and stops) units to
 comply with the configuration for that target, solving dependencies between
 units automatically. In its essence, a **systemd** target is a set of units
 that should be activated to reach a desired system state. These targets will
 typically include at least a text-based login or a graphical login screen
 being spawned.

A **systemd** target is a set of **systemd** units that should be started to
 reach a desired state. The most important of these targets are listed in the
 following table:

Target            | Purpose
----------------- | -------
graphical.target  | System supports multiple users, graphical and text-based logins.
multi-user.target | System supports multiple users, text-based logins only.
rescue.target     | **sulogin** prompt, basic system initialization completed.
emergency.target  | **sulogin** prompt, **initramfs** pivot complete and system root mounted on / read-only.

It is possible for a target to be a part of another target:

```
# systemctl list-dependencies graphical.target | grep target
graphical.target
● └─multi-user.target
●   ├─basic.target
●   │ ├─paths.target
●   │ ├─slices.target
●   │ ├─sockets.target
●   │ ├─sysinit.target
●   │ │ ├─cryptsetup.target
●   │ │ ├─local-fs.target
●   │ │ └─swap.target
●   │ └─timers.target
●   ├─getty.target
●   ├─nfs-client.target
●   │ └─remote-fs-pre.target
●   └─remote-fs.target
●     └─nfs-client.target
●       └─remote-fs-pre.target
```

An overview of all available targets can be viewed with:

```
# systemctl list-units --type=target --all
  UNIT                       LOAD      ACTIVE   SUB    DESCRIPTION                  
  basic.target               loaded    active   active Basic System                 
  cryptsetup.target          loaded    active   active Local Encrypted Volumes      
  emergency.target           loaded    inactive dead   Emergency Mode               
  getty-pre.target           loaded    inactive dead   Login Prompts (Pre)          
  getty.target               loaded    active   active Login Prompts                
  graphical.target           loaded    active   active Graphical Interface          
  initrd-fs.target           loaded    inactive dead   Initrd File Systems          
  initrd-root-device.target  loaded    inactive dead   Initrd Root Device           
  initrd-root-fs.target      loaded    inactive dead   Initrd Root File System      
  initrd-switch-root.target  loaded    inactive dead   Switch Root                  
  initrd.target              loaded    inactive dead   Initrd Default Target        
  local-fs-pre.target        loaded    active   active Local File Systems (Pre)     
  local-fs.target            loaded    active   active Local File Systems           
  multi-user.target          loaded    active   active Multi-User System            
  network-online.target      loaded    active   active Network is Online            
  network-pre.target         loaded    active   active Network (Pre)                
  network.target             loaded    active   active Network                      
  nfs-client.target          loaded    active   active NFS client services          
  nss-lookup.target          loaded    active   active Host and Network Name Lookups
  nss-user-lookup.target     loaded    active   active User and Group Name Lookups  
  paths.target               loaded    active   active Paths                        
  remote-fs-pre.target       loaded    active   active Remote File Systems (Pre)    
  remote-fs.target           loaded    active   active Remote File Systems          
  rescue.target              loaded    inactive dead   Rescue Mode                  
  rpc_pipefs.target          loaded    active   active rpc_pipefs.target            
  rpcbind.target             loaded    active   active RPC Port Mapper              
  shutdown.target            loaded    inactive dead   Shutdown                     
  slices.target              loaded    active   active Slices                       
  sockets.target             loaded    active   active Sockets                      
  sound.target               loaded    active   active Sound Card                   
  sshd-keygen.target         loaded    active   active sshd-keygen.target           
  swap.target                loaded    active   active Swap                         
  sysinit.target             loaded    active   active System Initialization        
● syslog.target              not-found inactive dead   syslog.target                
  time-sync.target           loaded    inactive dead   System Time Synchronized     
  timers.target              loaded    active   active Timers                       
  umount.target              loaded    inactive dead   Unmount All Filesystems      
  virt-guest-shutdown.target loaded    inactive dead   Libvirt guests shutdown      

LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.

38 loaded units listed.
To show all installed unit files use 'systemctl list-unit-files'.
```

An overview of all targets installed on disk can be viewed with:

```
# systemctl list-unit-files --type=target --all
UNIT FILE                     STATE   
anaconda.target               static  
basic.target                  static  
bluetooth.target              static  
cryptsetup-pre.target         static  
cryptsetup.target             static  
ctrl-alt-del.target           disabled
default.target                indirect
emergency.target              static  
exit.target                   disabled
final.target                  static  
getty-pre.target              static  
getty.target                  static  
graphical.target              indirect
halt.target                   disabled
hibernate.target              static  
hybrid-sleep.target           static  
initrd-fs.target              static  
initrd-root-device.target     static  
initrd-root-fs.target         static  
initrd-switch-root.target     static  
initrd.target                 static  
iprutils.target               disabled
kexec.target                  disabled
local-fs-pre.target           static  
local-fs.target               static  
machines.target               disabled
multi-user.target             static  
network-online.target         static  
network-pre.target            static  
network.target                static  
nfs-client.target             enabled 
nss-lookup.target             static  
nss-user-lookup.target        static  
paths.target                  static  
poweroff.target               disabled
printer.target                static  
rdma-hw.target                static  
reboot.target                 disabled
remote-cryptsetup.target      disabled
remote-fs-pre.target          static  
remote-fs.target              enabled 
rescue.target                 static  
rpc_pipefs.target             static  
rpcbind.target                static  
runlevel0.target              disabled
runlevel1.target              static  
runlevel2.target              static  
runlevel3.target              static  
runlevel4.target              static  
runlevel5.target              indirect
runlevel6.target              disabled
selinux-autorelabel.target    static  
shutdown.target               static  
sigpwr.target                 static  
sleep.target                  static  
slices.target                 static  
smartcard.target              static  
sockets.target                static  
sound.target                  static  
sshd-keygen.target            static  
suspend-then-hibernate.target static  
suspend.target                static  
swap.target                   static  
sysinit.target                static  
system-update-pre.target      static  
system-update.target          static  
time-sync.target              static  
timers.target                 static  
umount.target                 static  
virt-guest-shutdown.target    static  
vsftpd.target                 disabled

71 unit files listed.
```

On a running system, administrators can choose to switch to a different target
 using the ```systemctl isolate``` command:

```
# systemctl isolate multi-user.target
```

Isolating a target will stop all services not required by that target (and its
 dependencies), and start any required services that have not yet been started.

Not all targets can be isolated, only targets that have **AllowIsolate=yes** set
 in their unit files can be isolated.

```
# grep -irl "AllowIsolate=yes" /usr/lib/systemd/system/*
/usr/lib/systemd/system/anaconda.target
/usr/lib/systemd/system/ctrl-alt-del.target
/usr/lib/systemd/system/default.target
/usr/lib/systemd/system/emergency.target
/usr/lib/systemd/system/exit.target
/usr/lib/systemd/system/graphical.target
/usr/lib/systemd/system/halt.target
/usr/lib/systemd/system/initrd-switch-root.service
/usr/lib/systemd/system/initrd-switch-root.target
/usr/lib/systemd/system/initrd.target
/usr/lib/systemd/system/kexec.target
/usr/lib/systemd/system/multi-user.target
/usr/lib/systemd/system/poweroff.target
/usr/lib/systemd/system/reboot.target
/usr/lib/systemd/system/rescue.target
/usr/lib/systemd/system/runlevel0.target
/usr/lib/systemd/system/runlevel1.target
/usr/lib/systemd/system/runlevel2.target
/usr/lib/systemd/system/runlevel3.target
/usr/lib/systemd/system/runlevel4.target
/usr/lib/systemd/system/runlevel5.target
/usr/lib/systemd/system/runlevel6.target
/usr/lib/systemd/system/system-update.target
```

When the system starts, and control is passed over to **systemd** from the
 **initramfs**, **systemd** will try to activate the **default.target** target.
 Normally the **default.target** target will be a symbolic link (in
 **/etc/systemd/system/**) to either **graphical.target** or **multi-user.target**.

Instead of editing this symbolic link by hand, the **systemctl** tool comes
 with two commands to manage this link: **get-default** and **set-default**.

```
# systemctl get-default
multi-user.target
# systemctl set-default graphical.target
rm '/etc/systemd/system/default.target'
ln -s '/usr/lib/systemd/system/graphical.target' '/etc/systemd/system/default.target'
# systemctl get-default
graphical.target
```

To select a different target at boot time, a special option can be appended to
 the kernel command line from the boot loader.

1. (Re)boot the system.
2. Interrupt the boot loader menu countdown by pressing any key.
3. Move the cursor to the entry to be started.
4. Press **e** to edit the current entry.
5. Move the cursor to the line that starts with **linux16**. This is the kernel
 command line.
6. Append **systemd.unit=rescue.target** or any other target you wish to use.
7. Press **Ctrl+x** to boot with these changes.

## Repairing Common Boot Issues

To set a new **root** password, it is possible to have scripts that run from the
 **initramfs** pause at certain points, provide a **root** shell, and then 
 reset the password.

1. Reboot the system.
2. Interrupt the boot loader countdown by pressing any key.
3. Move the cursor to the entry that needs to be booted.
4. Press **e** to edit the selected entry.
5. Move the curso to the kernel command line (the line that starts with **linux16**).
6. Append **rd.break**. This will break just before control is handed from the
 **initramfs** to the actual system.
7. Press **Ctrl+x** to boot with the changes.

At this point a **root** shell will be presented, with the root file system for
 the actual system mounted read-only on **/sysroot**.

1. Remount **/sysroot** as read-write: 
 ```# mount -o remount,rw /sysroot```
2. Switch into **chroot** jail, where **/sysroot** is treated as the root of the
 file system tree:
 ```# chroot /sysroot```
3. Set a new root password:
 ```# passwd root```
4. Make sure that all unlabeled files (including **/etc/shadow** at this point)
 get relabeled during boot:
 ```# touch /.autorelabel```
5. Type **exit** twice. The first will exit the **chroot** jail, and the second
 will exit the **initramfs** debug shell.

At this point the system will continue booting, perform a full SELinux relabel,
 then reboot again.

It can be useful to look at the logs of previous (failed) boots. If the 
 **journald** log has been made persistent, this can be done with the
 **journalctl** tool.

First make sure that you have persistent **journald** logging enabled:

```
# mkdir -p -m2755 /var/log/journal
# chown :systemd-journal /var/log/journal
# killall -USR1 systemd-journald
```

To inspect the log files for a previous boot, use the **-b** option to
 **journalctl**. Without any arguments, the **-b** option will filter output
 only to messages pertaining to this boot, but with a negative number as an
 argument, it will filter on previous boots. For example:

```
# journalctl -b-1 -p err
```

This command will show all messages rated as an error or worse from the
 previous boot.

If there are problems during the starting of services, there are a few tools
 available that can help debug or troubleshoot.

By running ```systemctl enable debug-shell.service```, a **root** shell will be
 spawned on **TTY9 (Ctrl+Alt+F9)** early during the boot sequence. This shell
 is automatically logged in as root so that an administrator can use some other
 tools while the system is still booting. Once done, disable because this is a
 security risk.

By appending either **systemd.unit=rescue.target** or **systemd.unit=emergency.target**
 to the kernel command line frmo the boot loader, the system will spawn into a
 special rescue or emergency shell instead of starting normally. Both require
 the **root** password. The **emergency** target keeps the root file system
 mounted read-only, while **rescue.target** waits for **sysinit.target** to
 complete first so that more of the system will be initialized (e.g., loggin, 
 file systems, etc.).

During startup, **systemd** spawns a number of jobs. If some of these jobs
 cannot complete, they will block other jobs from running. To inspect the
 current job list, an administrator can use the comman ```systemctl list-jobs```.
 Any jobs listed as **running** must complete before the jobs listed as
 **waiting** can continue.

## Repairing File System Issues At Boot

Errors in **/etc/fstab** and corrupt file systems can stop a system from booting.
 In most cases, **systemd** will actually continue to boot after a timeout, or
 drop to an emergency repair shell that requires the **root** password.

* Corrupt file system - **systemd** will attempt a ```fsck```. If the problem
 is too serious for an automatic fix, the user will be prompted to run ```fsck```
 manually from an emergency shell.
* Non-existent device/UUID referenced in /etc/fstab - **systemd** will wait for
 a set amount of time, waiting for the device to become available. If the device
 does not become available, the user is dropped to an emergency shell after the
 timeout.
* Non-existent mount point in /etc/fstab - **systemd** creates the mount point
 if possible; otherwise, it drops to an emergency shell.
* Incorrect mount option specified in /etc/fstab - The user is dropped to an
 emergency shell.

In all cases, an administrator can also utilize the **emergency.target** target
 to diagnose and fix the issue, since no file systems will be mounted before the
 emergency shell is displayed.

When using the automatic recovery shell during file system issues, do not forget
 to issue a ```systemctl daemon-reload``` after editing **/etc/fstab**. Without
 this reload, **systemd** will continue using the old version.

## Repairing Boot Loader Issues

The boot loader used by default on RHEL7/8 is grub2, the second major version of
 the GRand Unified Bootloader.

The main configuration file for grub2 is **/boot/grub2/grub.cfg**, but 
 administrators are not supposed to edit this file directly. Instead, a tool 
 called ```grub2-mkconfig``` is used to generate that configuration using a
 set of different configuration files, and the list of installed kernels.

```grub2-mkconfig``` will look at **/etc/default/grub** for options such as the
 default menu timeout and kernel command line to use, then use a set of scripts
 in **/etc/grub.d/** to generate a configuration file.

To make permanent changes to the boot loader configuration, an administrator
 needs to edit the configuration files listed previously, then run the following
 command: ```# grub2-mkconfig > /boot/grub2/grub.cfg```

To troubleshoot a broken **grub2** configuration, an administrator will need to
 understand the syntax of **/boot/grub2/grub.cfg** first.

Bootable entries are encoded inside **menuentry** blocks. In these blocks, 
 **linux16** and **initrd16** lines point to the kernel to be loaded from 
 disk (along with the kernel command line) and the **initramfs** to be loaded.

The **set root** lines inside those blocks points to the file system from which
 **grub2** should load the kernel and initramfs files. The syntax is
 **harddrive,partition**, where **hd0** is the first hard drive in the system,
 **hd1** is the second, etc. The partitions are indicated as **gpt1** for the
 first GPT partition on that drive.

In cases where the boot loader itself has become corrupted, it can be reinstalled
 using the ```grub2-install``` command.
