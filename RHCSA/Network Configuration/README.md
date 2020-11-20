# Network Configuration

## Validating Network Configuration

## Configuring Networking With nmcli

## Editing Network Configuration Files

It is possible to configure the network by editing interface configuration files.
 Interface configuration files control the software interfaces for individual
 network devices. These files are usually named 
 **/etc/sysconfig/network-scripts/ifcfg-<name>**, where <name> refers to the
 name of the device or connection that the configuration file controls. The
 following are standard variables found in the file used for static or dynamic
 configuration.

After modifying the configuration files, run ```nmcli con reload``` to make
 NetworkManager read the configuration changes. The interface still needs to be
 restarted for the changes to take effect.

```
# nmcli con reload
# nmcli con down "System eth0"
# nmcli con up "System eth0"
```

## Configuring Host Names and Name Resolution

The ```hostname``` command displays or temporarily modifies the system's
 fully qualified host name.

```
# hostname
desktopX.example.com
```

A static host name may be specified in the **/etc/hostname** file. The
 ```hostnamectl``` command is used to modify this file. If this file does not
 exist, the host name is set by a reverse DNS query once the interface has an
 IP address assigned.

```
# hostnamectl set-hostname desktopX.example.com
# hostnamectl status
 Static hostname: desktopX.example.com
       Icon name: n/a
         Chassis: computer
      Machine ID: 9f6fb63045a845d79e5e870b914c61c9
         Boot ID: aa6c3259825e4b8c92bd0f601089ddf7
  Virtualization: kvm
Operating System: Red Hat Enterprise Linux Server 7.0 (Maipo)
     CPE OS Name: cpe:/o:redhat:enterprise_linux:7.0:GA:server
          Kernel: Linux 3.10.0-97.el7.x86_64
    Architecture: x86_64
# cat /etc/hostname
desktopX.example.com
```

The _stub resolver_ is used to convert host names to IP addresses or the
 reverse. The contents of the file **/etc/hosts** are checked first.

```
# cat /etc/hosts
127.0.0.1       localhost localhost.localdomain localhost4 localhost4.localdomain4
::1             localhost localhost.localdomain localhost6 localhost6.localdomain6
172.25.254.254  classroom.example.com
172.25.254.254  content.example.com
```

The ```getent hosts hostname``` command can be used to test host name
 resolution with the **/etc/hosts** file.

If an entry is not found in that file, the stub resolver looks for the
 information from a DNS nameserver. The **/etc/resolv.conf** file controls how
 this query is done:

* **nameserver**: The IP address of a nameserver to query. Up to three
 nameserver directives may be given to provide backups if one is down.
* **search**: A list of domain names to try with a short host name. Both this
 and **domain** should not be set in the same file; if they are, the last
 instance wins.

NetworkManager will update the **/etc/resolv.conf** file using DNS settings in
 the connection configuration files. Use the ```nmcli``` command to modify the
 connections:

```
# nmcli con mod ID ipv4.dns IP
# nmcli con down ID
# nmcli con up ID
# cat /etc/sysconfig/network-scripts/ifcfg-ID
...
DNS1=8.8.8.8
...
```

The default behavior of ```nmcli con mod ID ipv4.dns IP``` is to replace any
 previous DNS settings with the new IP list provided. A **+/-** symbol in front
 of the **ipv4.dns** argument will add or remove an individual entry.

```
# nmcli con mod ID +ipv4.dns IP
```

The ```host HOSTNAME``` command can be used to test DNS server connectivity.

```
# host classroom.example.com
classroom.example.com has address 172.25.254.254
# host 172.25.254.254
254.254.25.172.in-addr.arpa domain name pointer classroom.example.com
```

