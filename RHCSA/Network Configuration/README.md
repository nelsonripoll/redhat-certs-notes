# Network Configuration

## Validating Network Configuration

The ```/sbin/ip``` command is used to show device and address information.

1. An active interface has the status of **UP**.
2. The link line specifies the hardware (MAC) address of the device.
3. The inet line shows the IPv4 address and prefix. The broadcast address, scope, 
 and device name are also on this line.
4. The inet6 line shows the IPv6 information.

```
# ip addr show enp2s0
2: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 64:00:6a:16:83:3f brd ff:ff:ff:ff:ff:ff
    inet 192.168.33.34/24 brd 192.168.33.255 scope global dynamic noprefixroute enp2s0
       valid_lft 239922sec preferred_lft 239922sec
    inet6 fe80::25f:2991:4f5c:40df/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```

The ```ip``` command may also be used to show statistics about network performance.

```
# ip -s link show enp2s0
2: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 64:00:6a:16:83:3f brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast   
    612892519  1471811  0       0       0       361240  
    TX: bytes  packets  errors  dropped carrier collsns 
    8356307    122610   0       0       0       0
```

The ```/sbin/ip``` command is also used to show routing information.

```
# ip route
default via 192.168.33.1 dev enp2s0 proto dhcp metric 100 
192.168.33.0/24 dev enp2s0 proto kernel scope link src 192.168.33.34 metric 100 
192.168.100.0/24 dev virbr1 proto kernel scope link src 192.168.100.1 linkdown 
192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1 linkdown 
```

The ```ping``` command is used to test connectivity.

To trace the path to a remote host, use either ```traceroute``` or ```tracepath```.
 Both commands can be used to trace a path with UDP packets; however, many
 networks block UDP and ICMP traffic.

```
# tracepath access.redhat.com
...
 2:  untangle.fbdlp.local                                  0.317ms asymm  3 
 3:  12.221.11.33                                          1.522ms asymm  4 
 4:  12.247.96.133                                         2.791ms asymm  6 
 5:  cr1.santx.ip.att.net                                  4.145ms asymm  8 
 6:  12.123.236.81                                         2.885ms asymm  7 
 7:  12.123.236.170                                       35.241ms asymm 16 
 8:  hs1tx21crs.ip.att.net                                40.566ms asymm 15 
 9:  nwrla21crs.ip.att.net                                37.365ms asymm 14 
10:  nwrla22crs.ip.att.net                                37.853ms asymm 13 
11:  gbr7.cgcil.ip.att.net                                40.873ms asymm 12 
12:  12.240.210.97                                        33.515ms asymm 11 
13:  12.117.182.158                                       34.068ms 
...
```

Each line in the output of ```tracepath``` represents a router or _hop_ that
 the packet passes through between the source and the final destination.

TCP services use sockets as end points for communication and are made up of an
 IP address, protocol, and port number. Well-known names for standard ports
 are listed in the **/etc/services** file.

The ```ss``` command is used to display socket statistics.

```
# ss -ta
State        Recv-Q       Send-Q             Local Address:Port                  Peer Address:Port
LISTEN       0            128                      0.0.0.0:hostmon                    0.0.0.0:*
LISTEN       0            128                      0.0.0.0:sunrpc                     0.0.0.0:*
LISTEN       0            32                 192.168.100.1:domain                     0.0.0.0:*
LISTEN       0            32                 192.168.122.1:domain                     0.0.0.0:*
LISTEN       0            128                      0.0.0.0:ssh                        0.0.0.0:*
LISTEN       0            5                      127.0.0.1:ipp                        0.0.0.0:*
LISTEN       0            128                         [::]:hostmon                       [::]:*
LISTEN       0            128                         [::]:sunrpc                        [::]:*
LISTEN       0            32                             *:ftp                              *:*
LISTEN       0            128                         [::]:ssh                           [::]:*
LISTEN       0            5                          [::1]:ipp                           [::]:*
```


## Configuring Networking With nmcli

NetworkManager is a daemon that monitors and manages network settings. Command-line
 and graphical tools talk to NetworkManager and save configuration files in the
 **/etc/sysconfig/network-settings** directory.

A _device_ is a network interface. A _connection_ is a configuration used for a
 device which is made up of a collection of settings. Multiple connections may
 exist for a device, but only one may be active at a time.

To display a list of all connections, use ```nmcli con show```. To list only
 the active connections, add the **--active** option.

Specify a connection ID (name) to see the details of that connection. Settings
 and property names are defined in the **nm-settings** man page.

The ```nmcli dev``` command can also be used to show device status and details.

When creating a new connection with ```nmcli```, the order of the arguments is
 important. The common arguments appear first and must include the type and
 interface. Next, specify any type-specific arguments and finally specify the
 IP address, prefix, and gateway information. Multiple IP addresses may be
 specified for a single device. Additional settings such as a DNS server are
 set as modifications once the connection exists.

1. Define a new connection named "default" which will autoconnect as an Ethernet
 connection on the eth0 device using DHCP.
2. Create a new connection named "static" and specify the IP address and gateway.
 Do not autoconnect2. Create a new connection named "static" and specify the IP address and gateway.
  Do not autoconnect.
3. The system will autoconnect with the DHCP connection at boot. Change to the
 static connection.
4. Change back to the DHCP connection.

```
# nmcli con add con-name "default" type ethernet ifname eth0
# nmcli con add con-name "static" ifname eth0 autoconnect no type ethernet ip4 172.25.0.10/24 gw4 172.25.0.254
# nmcli con up "static"
# nmcli con up "default"
```

Type options depend on the type used. To view all the type options, use
 ```nmcli con add help```. Examples may include ethernet, wifi, bridge, bond,
 team, VPN, and VLAN.

An existing connection may be modified with ```nmcli con mod``` arguments. Use
 ```nmcli con show "ID"``` to see a list of current values for a connection.

1. Turn off autoconnect.
2. Specify a DNS server.
3. Some configuration arguments may have values added or removed. Add a +/-
 symbol in front of the argument. Add a secondary DNS server.
4. Replace the static IP address and gateway.
5. Add a secondary IP address without a gateway.

```
# nmcli con mod "static" connection.autoconnect no
# nmcli con mod "static" ipv4.dns 172.25.0.254
# nmcli con mod "static" +ipv4.dns 8.8.8.8
# nmcli con mod "static" ipv4.addresses "172.25.0.10/24 172.25.0.254"
# nmcli con mod "static" +ipv4.addresses 10.10.10.10/16
```

**nmcli commands**

Command                | Use
---------------------- | ------------------------------------------------------------
nmcli dev status       | List all devices.
nmcli con show         | List all connections.
nmcli con up "ID"      | Activate a connection.
nmcli con down "ID"    | Deactivate a connection.
nmcli dev dis DEV      | Bring down an interface and temporarily disable autoconnect.
nmcli net off          | Disable all managed interfaces.
nmcli con add ...      | Add a new connection.
nmcli con mod "ID" ... | Modify a connection.
nmcli con del "ID"     | Delete a connection.

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

