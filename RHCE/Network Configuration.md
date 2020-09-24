# Network Configuration

## Network Teaming
Network Teaming is a method of taking multiple network inferface adapters and combining
 them so that you can either a) load balance them or b) have them in an active,
 passive role. In other words, you define a single interface that contains
 multiple network interface physical devices, and you assign an IP address,
 and they either load balance the connections or one is set up as a primary and
 the others are set as backups to the primary.

You can also aggregate them so that you can use the network bandwidth of multiple
 ports if you have a network infrastructure that can support it.

The commands are largely the same whether you're setting up an active/backup, 
 load balancer, or aggregate.

### Active/Backup Scenario
As you can see in this scenario we have three ethernet network interfaces. We 
 are going to team up eth1 and eth2 onto a single IP address.
```
# ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 192.168.0.11  netmask 255.255.255.0  broadcast 192.168.0.255
        inet6 fe80::80a:c3ff:fe57:d1a5  prefixlen 64  scopeid 0x20<link>
        ether 0a:0a:c3:57:d1:a5  txqueuelen 1000  (Ethernet)
        RX packets 7419  bytes 10303436 (9.8 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2529  bytes 195032 (190.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether 0a:ca:8f:f9:a9:b5  txqueuelen 1000  (Ethernet)
        RX packets 13  bytes 1294 (1.2 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 11  bytes 1434 (1.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether 0a:b8:23:a8:86:c1  txqueuelen 1000  (Ethernet)
        RX packets 13  bytes 1294 (1.2 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 11  bytes 1434 (1.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

First we need to add a new team connection type named netteam0 configured as an
 active/backup. We need to set the IP address to manual so it does not accidentally
 pick up a DHCP IP address and cause conflict.
```
# nmcli con add type team con-name netteam0 ifname netteam0 config '{"runner":{"name":"activebackup"}}'
Connection 'netteam0' (3dc69f12-ab0a-464f-bc66-d727e5b7f54f) successfully added.
# nmcli con mod netteam0 ipv4.addresses '192.168.0.10/24'
# nmcli con mod netteam0 ipv4.method manual
# ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 192.168.0.11  netmask 255.255.255.0  broadcast 192.168.0.255
        inet6 fe80::80a:c3ff:fe57:d1a5  prefixlen 64  scopeid 0x20<link>
        ether 0a:0a:c3:57:d1:a5  txqueuelen 1000  (Ethernet)
        RX packets 7419  bytes 10303436 (9.8 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2529  bytes 195032 (190.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether 0a:ca:8f:f9:a9:b5  txqueuelen 1000  (Ethernet)
        RX packets 13  bytes 1294 (1.2 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 11  bytes 1434 (1.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether 0a:b8:23:a8:86:c1  txqueuelen 1000  (Ethernet)
        RX packets 13  bytes 1294 (1.2 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 11  bytes 1434 (1.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

netteam0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.0.10  netmask 255.255.255.0  broadcast 192.168.0.255
        inet6 fe80::f646:abf8:30e7:8af2  prefixlen 64  scopeid 0x20<link>
        ether 0a:b8:23:a8:86:c1  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 34 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

# teamdctl netteam0 state
setup:
  runner: activebackup
runner:
  active port:
```

As you can see even though netteam0 is set up as an active backup, there are no
 ports associated with it. Now we need to start adding ports to the configuration.
```
# nmcli con add type team-slave con-name netteam0-port1 ifname eth1 master netteam0
Connection 'netteam0-port1' (a533052d-f298-48e1-9295-52ee687c62f5) successfully added.
# nmcli con add type team-slave con-name netteam0-port2 ifname eth2 master netteam0
Connection 'netteam0-port2' (5ff936a9-5f50-4dc1-ae9a-9d1e4742d466) successfully added.
# nmcli con up netteam0-port1
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/7)
# nmcli con up netteam0-port2
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/11)
# nmcli con up netteam0
Connection successfully activated (master waiting for slaves) (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/12)
# teamdctl netteam0 state
setup:
  runner: activebackup
ports:
  eth0
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link: up
        down count: 0
  eth1
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link: up
        down count: 0

runner:
  active port: eth0
```

Now eth1 and eth2 are associated to our active/backup network team netteam0. If
 we take down eth1, eth2 will become the new primary interface the network team.
 If we bring eth1 back up, eth2 will remain as the primary interface so the network
 traffic is not interrupted.
```
# nmcli con down netteam0-port1
Connection 'netteam0-port1' successfully deactivated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/7)
# teamdctl netteam0 state
setup:
  runner: activebackup
ports:
  eth1
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link: up
        down count: 0

runner:
  active port: eth1
# nmcli con up netteam0-port1
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/7)
# teamdctl netteam0 state
setup:
  runner: activebackup
ports:
  eth0
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link: up
        down count: 0
  eth1
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link: up
        down count: 0

runner:
  active port: eth1
```

## Configure IPv6 Addresses

Working with IPv6 addresses using the network manager is exactly the same as working
 with IPv4 addresses. Using the NetworkManager command line interface, users can 
 manually set and test both IPv4 and IPv6 connections.

```
# ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 10.0.0.216  netmask 255.255.255.0  broadcast 10.0.0.255
        inet6 fe80::15:1cff:fe01:8ea5  prefixlen 64  scopeid 0x20<link>
        ether 02:15:1c:01:8e:a5  txqueuelen 1000  (Ethernet)
        RX packets 52906  bytes 78401906 (74.7 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 21527  bytes 1590050 (1.5 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether 02:b2:dc:05:d6:81  txqueuelen 1000  (Ethernet)
        RX packets 7  bytes 418 (418.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 96  bytes 8192 (8.0 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 96  bytes 8192 (8.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

# nmcli con add con-name eth1 type ethernet ifname eth1
Connection 'eth1' (7321a434-e5d6-4339-b896-982adae19256) successfully added.
# nmcli con mod eth1 ipv4.addresses '192.168.10.100/24'
# nmcli con mod eth1 ipv4.method manual
# nmcli con mod eth1 ipv6.addresses fddb:fe2a:ab1e::c0a8:64/64
# nmcli con mod eth1 ipv6.method manual
# nmcli con up eth1
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/2)
# ping -I eth1 192.168.10.100
# ping6 -I eth1 fddb:fe2a:ab1e::c0a8:64
```

## Route IP Traffic By Creating Static Routes

```
# ip route list
default via 10.0.0.1 dev eth0
10.0.0.0/24 dev eth0 proto kernel scope link src 10.0.0.235
169.254.0.0/16 dev eth0 scope link metric 1002
192.168.33.0 via 192.168.33.1 dev eth1 scope link
192.168.33.0/24 dev eth1 proto kernel scope link src 192.168.33.1
# ping google.com
# traceroute 172.217.13.238
# ip route add 172.217.13.0/24 via 192.168.33.1 dev eth1
# ip route list
default via 10.0.0.1 dev eth0
10.0.0.0/24 dev eth0 proto kernel scope link src 10.0.0.235
169.254.0.0/16 dev eth0 scope link metric 1002
172.217.13.0/24 via 192.168.33.1 dev eth1
192.168.33.0 via 192.168.33.1 dev eth1 scope link
192.168.33.0/24 dev eth1 proto kernel scope link src 192.168.33.1
# ping 172.217.13.238
# traceroute 172.217.13.238
# ip route del 172.217.13.0/24 via 192.168.33.1 dev eth1
# ping 172.217.13.238
# any net 172.217.13.0 netmask 255.255.255.0 gw 10.0.0.1 dev eth0 
# ping 172.217.13.238
# traceroute 172.217.13.238
```
