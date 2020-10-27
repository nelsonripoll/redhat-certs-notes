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

ZONE NAME | DEFAULT CONFIGURATION
--------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
trusted   | Allow all incoming traffic.
home      | Reject incoming traffic unless related to outgoing traffic or matching the **ssh**, **mdns**, **ipp-client**, **samba-client**, or **dhcpv6-client** pre-defined services.
internal  | Reject incoming traffic unless related to outgoing traffic or matching the **ssh**, **mdns**, **ipp-client**, **samba-client**, or **dhcpv6-client** pre-defined services (same as the **home** zone to start with).
work      | Reject incoming traffic unless related to outgoing traffic or matching the **ssh**, **ipp-client**, or **dhcpv6-client** pre-defined services.
public    | Reject incoming traffic unless related to outgoing traffic or matching the **ssh** or **dhcpv6-client** pre-defined services. The default zone for newly-added network interfaces.
external  | Reject incoming traffic unless related to outgoing traffic or matching the **ssh** pre-defined service. Outgoing IPv4 traffic forwarded through this zone is masqueraded to look like it originated from the IPv4 address of the outgoing network interface.
dmz       | Reject incoming traffic unless related to outgoing traffic or matching the **ssh** pre-defined service.
block     | Reject incoming traffic unless related to outgoing traffic.
drop      | Drop all incoming traffic unless related to outgoing traffic (do not even respond with ICMP errors).

### Pre-Defined Services

**firewalld** ships with a number of pre-defined services. These service
 definitions can be used to easily permit traffic for particular network
 services to pass through the firewall. To view a list of the pre-defined
 services, run ```firewall-cmd --get-services```. The configuration files can
 be found in the **/usr/lib/firewalld/services** directory.

**Common TCP/IP Ports**

Service       | Default Port     | Configuration
------------- | ---------------- | -------------
ssh           | 22/tcp           | Local SSH server.
ftp           | 20/tcp, 21/tcp   | Local FTP server.
telnet        | 23/tcp           | Local telnet protocal port.
smtp          | 25/tcp           | Simple Mail Transfer Protocol; SMTP is a push protocol for a mail server.
dns           | 53/tcp           | Domain Name Server; DNS is a hierarchical and decentralized naming system for computers, services, or other systems connected to a network.
http          | 80/tcp           | Local HTTP server.
kerberos      | 88/tcp           | Kerberos is a network authentication protocol.
pop3          | 110/tcp          | Local POP3 mail server.
imap          | 143/tcp          | Local IMAP mail server.
https         | 443/tcp          | Local HTTPS server.
dhcpv6-client | 546/udp          | Local DHCPv6 client.
ipp-client    | 631/udp          | Internet Printing Protocol; IPP is a protocol for communication between client devices and printers (or print servers).
samba-client  | 137/udp, 138/udp | Windows file and print sharing client.
mdns          | 5353/udp         | Multicast DNS local-link name resolution.

## Configure Firewall Settings 

There are three main ways for system administrators to interact with **firewalld**.

* By directly editing configuration files in **/etc/firewalld/**.
* By using the graphical **firewall-config** tool.
* By using ```firewall-cmd``` from the command line.

The first two are not discussed here. The ```firewall-cmd``` command is installed
 as part of the **firewalld** package. ```firewall-cmd``` can perform the same
 actions that **firewall-config** can.

The following table lists a number of frequently used ```firewall-cmd``` commands,
 along with an explanation. Note that unless otherwise specified, almost all 
 commands will work on the runtime configuration, unless the **--permanent** 
 option is specified. Many of the commands listed take the **--zone=<ZONE>**
 option to determine which zone they affect.

FIREWALL-CMD COMMANDS          | EXPLANATION
------------------------------ | -------------------------------------------------------------------------------------------------------
--get-default-zone             | Query the current default zone.
--set-default-zone=<ZONE>      | Set the default zone. This changes both the runtime and the permanent configuation.
--get-zones                    | List all available zones.
--get-active-zones             | List all zones currently in use, along with their interface and source information.
--zone=<ZONE>                  | Use to specify which zone the changes are being applied to. If not specified, the default zone is used.
--add-source=<CIDR>            | Route all traffic coming from the IP address or network/netmask <CIDR> to the zone.
--remove-source=<CIDR>         | Remove the rule routing all traffic coming from the IP address or network/netmask <CIDR> from the zone.
--add-interface=<INTERFACE>    | Route all traffic coming from <INTERFACE> to the zone.
--change-interface=<INTERFACE> | Associate the interface with a zone.
--list-all                     | List all configured interfaces, sources, services, and ports for the zone.
--list-all-zones               | Retrieve all information for all zones.
--add-service=<SERVICE>        | Allow traffic to <SERVICE> for the zone.
--remove-service=<SERVICE>     | Remove <SERVICE> from the allowed list for the zone.
--add-port=<PORT/PROTOCOL>     | Allow traffic to the <PORT/PROTOCOL> port(s) for the zone.
--remove-port=<PORT/PROTOCOL>  | Remove the <PORT/PROTOCOL> port(s) from the allowed list for the zone.
--permanent                    | Add the change to the permanent configuration.
--reload                       | Drop the runtime configuration and apply the persistent configuration.

```
# firewall-cmd --set-default-zone=dmz
# firewall-cmd --permanent --zone=internal --add-source=192.168.0.0/24
# firewall-cmd --permanent --zone=internal --add-service=mysql
# firewall-cmd --reload
```



