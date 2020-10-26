# Basic Firewall Control

The linux kernel comes with a powerful framework, the netfilter system, which
 enables other kernel modules to offer functionalities such as packet filtering,
 network address translation (NAT), and load balancing. This means any incoming,
 outgoing, or forwarded network packet can be inspected, modified, dropped, or
 rejected in a programmatic way, before reaching components in user space.

The **iptables** command is a well-known, low-level tool used to interact with
 netfilter. Other utilities, such as **ip6tables** for IPv6 and **ebtables** for 
 software bridges, need to be used for more complete firewall coverage. Recently, 
 a new method has been introduced to interact with netfilter: **firewalld**.

## Firewalld

**firewalld** is a system daemon that can configure and monitor the system
 firewall rules. Applications can talk to **firewalld** to request ports to be
 opened using DBus messaging system, a feature which can be disabled or locked
 down. It covers IPv4, IPv6, and potentially **ebtables** settings.

**firewalld** simplifies firewall management by classifying all network traffic
 into zones. Based on criteria such as the source IP address of a packet or
 the incoming network interface, traffic is then diverted into the firewall rules
 for the appropriate zone. Each zone has its own list of ports and services to
 be opened or closed.

Every packet that comes into the system will first be checked for its source
 address. If that source address is tied to a specific zone, the rules for that
 zone will be parsed. If the source address is not tied to a zone, the zone for
 the incoming network interface will be used. If the network interface is not 
 associated with a zone for some reason, the default zone will be used.

### Pre-Defined Zones

**firewalld** ships with a number of pre-defined zones, suitable for various
 purposes. The default zone is set to public and interfaces are assigned to
 public if no changes are made. The **lo** interface is treated as if it were
 in the trusted zone.

#### trusted

Allow all incoming traffic.

#### home

Reject incoming traffic unless related to outgoing traffic or matching the **ssh**,
 **mdns**, **ipp-client**, **samba-client**, or **dhcpv6-client** pre-defined
 services.

#### internal

Reject incoming traffic unless related to outgoing traffic or matching the **ssh**,
 **mdns**, **ipp-client**, **samba-client**, or **dhcpv6-client** pre-defined
 services (same as the **home** zone to start with).

#### work

Reject incoming traffic unless related to outgoing traffic or matching the **ssh**,
 **ipp-client**, or **dhcpv6-client** pre-defined services.

#### public

Reject incoming traffic unless related to outgoing traffic or matching the **ssh**
 or **dhcpv6-client** pre-defined services. The default zone for newly-added
 network interfaces.

#### external

Reject incoming traffic unless related to outgoing traffic or matching the **ssh**
 pre-defined service. Outgoing IPv4 traffic forwarded through this zone is
 masqueraded to look like it originated from the IPv4 address of the outgoing
 network interface.

#### dmz
Reject incoming traffic unless related to outgoing traffic or matching the **ssh**
 pre-defined service.

#### block

Reject incoming traffic unless related to outgoing traffic.

#### drop

Drop all incoming traffic unless related to outgoing traffic (do not even respond
 with ICMP errors).


### Pre-Defined Services

**firewalld** ships with a number of pre-defined services. These service
 definitions can be used to easily permit traffic for particular network
 services to pass through the firewall. To view a list of the pre-defined
 services, run ```firewall-cmd --get-services```. The configuration files can
 be found in the **/usr/lib/firewalld/services** directory.

**Common TCP/IP Ports**

Service  | Port
-------- | ------
ssh      | 22
ftp      | 20, 21
telnet   | 23
smtp     | 25
dns      | 53
http     | 80
kerberos | 88
pop3     | 110
imap     | 143
https    | 443
