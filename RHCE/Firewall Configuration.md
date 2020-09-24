# Firewall Configuration

## Manage Firewall Service
```
# systemctl start firewalld
# systemctl enable firewalld
# systemctl status firewalld
```

## Source Management
If you do not use the **--zone** option, the sources will be added or removed from
 the default zone.
```
# firewall-cmd --permanent --add-source=192.168.122.100
# firewall-cmd --permanent --remove-source=192.168.122.100
# firewall-cmd --reload
```

## Service Management
If you do not use the **--zone** option, the service will be added or removed from
 the default zone.
```
# firewall-cmd --list-services
# firewall-cmd --permanent --zone=work --add-service=http
# firewall-cmd --permanent --zone=work --remove-service=http
# firewall-cmd --reload
```

### Predefined Services
View a list of available predefined services.
```
# ls /usr/lib/firewalld/services
# ls /etc/firewalld/services
```

All files will be in **.xml** format.
```
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>My Service</short>
  <description>description</description>
  <port port="137" protocol="tcp"/>
  <protocol value="igmp"/>
  <module name="nf_conntrack_netbios_ns"/>
  <destination ipv4="224.0.0.251" ipv6="ff02::fb"/>
</service>
```

Files in **/usr/lib/firewalld/services** should not be edited, only edit files in
 **/etc/firewalld/services**.

## Port Management
```
# firewall-cmd --list-ports
# firewall-cmd --permanent --add-port=100/tcp
# firewall-cmd --permanent --add-port=200-300/tcp
```

## Zones

Display a list of zones.
```
# firewall-cmd --get-zones
block dmz drop external home internal public trusted work
```

Display the zone currently set as the default and change the default zone.
```
# firewall-cmd --get-default-zone
public

# firewall-cmd --set-default-zone=home
success
```

View the specific configuration of the default zone.
```
# firewall-cmd --list-all
home
  interfaces:
  sources:
  services: dhcpv6-client ipp-client mdns samba-client ssh
  ports:
  masquerade: no
  forward-ports:
  icmp-blocks:
  rich rules:
```

View the specific configuration of a zone not set as the default zone.
```
# firewall-cmd --zone=public --list-all
public
  interfaces:
  sources:
  services: http https
  ports:
  masquerade: no
  forward-ports:
  icmp-blocks:
  rich rules:
```

View the configuration of all zones.
```
# firewall-cmd --list-all-zones
...

home
  interfaces:
  sources:
  services: dhcpv6-client ipp-client mdns samba-client ssh
  ports:
  masquerade: no
  forward-ports:
  icmp-blocks:
  rich rules:

...

public
  interfaces:
  sources:
  services: http https
  ports:
  masquerade: no
  forward-ports:
  icmp-blocks:
  rich rules:

...
```

### Predefined Zones

* drop: The lowest level of trust. All incoming connections are dropped without reply and only outgoing connections are possible.
* block: Similar to the above, but instead of simply dropping connections, incoming requests are rejected with an icmp-host-prohibited or icmp6-adm-prohibited message.
* public: Represents public, untrusted networks. You don’t trust other computers but may allow selected incoming connections on a case-by-case basis.
* external: External networks in the event that you are using the firewall as your gateway. It is configured for NAT masquerading so that your internal network remains private but reachable.
* internal: The other side of the external zone, used for the internal portion of a gateway. The computers are fairly trustworthy and some additional services are available.
* dmz: Used for computers located in a DMZ (isolated computers that will not have access to the rest of your network). Only certain incoming connections are allowed.
* work: Used for work machines. Trust most of the computers in the network. A few more services might be allowed.
* home: A home environment. It generally implies that you trust most of the other computers and that a few more services will be accepted.
* trusted: Trust all of the machines in the network. The most open of the available options and should be used sparingly.



## Rich Rules
```
firewall-cmd --permanent --zone=home --add-rich-rule='rule family=ipv4 source address=192.168.122.100 service name="http" log level=notice prefix="NEW HTTP RULE   " limit value="100/s" accept'
firewall-cmd --permanent --zone=home --remove-rich-rule='rule family=ipv4 source address=192.168.122.100 service name="http" log level=notice prefix="NEW HTTP RULE   " limit value="100/s" accept'

firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=192.168.122.100 forward-port port=443 protocol=tcp to-port=22'
firewall-cmd --permanent --remove-rich-rule='rule family=ipv4 source address=192.168.122.100 forward-port port=443 protocol=tcp to-port=22'
```
