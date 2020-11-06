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
