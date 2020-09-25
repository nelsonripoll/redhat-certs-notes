# Labs

## Lab 1

### Question

List virtualization packages required to install KVM.

Install virtualization packages.

### Answer

**Packages**

Package        | Description
-------------- | -------------------------------------------------------------
qemu-kvm       | The main KVM package.
libvirt        | The libvirtd service to manage hypervisors.
libvirt-client | The virsh command and clients API to manage virtual machines.
virt-install   | Command-line tools for creating VMs.
virt-manager   | GUI VM administration tool.
virt-top       | Command to display virtualization statistics.
virt-viewer    | Graphical console to connect to VMs.

```
# dnf install -y qemu-kvm libvirt libvirt-client virt-install virt-manager virt-top virt-viewer
```

**Package Groups**

Group                     | Description
------------------------- | -------------------------------------------------------------
Virtualization Hypervisor | Smallest possible virtualization host installation. 
Virtualization Tools      | Tools for offline virtual image management.
Virtualization Client     | Clients for installing and managing virtualization instances.

```
# dnf group install -y "Virtualization Hypervisor" "Virtualization Tools" "Virtualization Client"
```

## Lab 2a

### Question

Using the Virtual Machine Manager, create two virtual networks based on the table
 below.

Name     | Mode | IPv4 Network
-------- | ---- | ----------------
insider  | NAT  | 192.168.122.0/24
outsider | NAT  | 192.168.100.0/24


### Answer

1. Open Virtual Machine Manager. Once opened, select the connection and open
 Connection Details under the Edit menu.

2. Click on the Virtual Networks tab, click the Add Network button at the bottom.

3. Set the name, mode, and IPv4 network.

4. Click Finish once completed. Repeat for the other networks.

## Lab 2b

### Question

Using the virsh command, create two virtual networks based on the table
 below.

Name     | Mode | IPv4 Network
-------- | ---- | ----------------
insider  | NAT  | 192.168.122.0/24
outsider | NAT  | 192.168.100.0/24


### Answer

Create two XML files for both networks.

**insider.xml**
```
<network>
  <name>insider</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr0' stp='on' delay='0'/>
  <domain name='insider'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.128' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```

```
# virsh --connect qemu:///system net-define --file insider.xml 
# virst --connect qemu:///system net-start insider
```

**outsider.xml**
```
<network>
  <name>outsider</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr1' stp='on' delay='0'/>
  <domain name='outsider'/>
  <ip address='192.168.100.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.100.128' end='192.168.100.254'/>
    </dhcp>
  </ip>
</network>
```

```
# virsh --connect qemu:///system net-define --file outsider.xml 
# virst --connect qemu:///system net-start outsider
```

## Lab 3a

### Question

Using the Virtual Machine Manager, create a new VM based on the information below.
 Use the lab results from the **Simple HTTP and FTP** lab as the kickstart server.

Resource  | Value
--------- | ----------------------
Name      | labmachine
RAM       | 1536
CPU       | 1
Harddrive | 16 GiB
Network   | insider 
Hostname  | labmachine.example.com
IPv4      | 192.168.122.100

### Answer

1. Open Virtual Machine Manager, right click the preferred connection and click
 New.

2. Select Network Install (HTTP, HTTPS, or FTP).

3. Enter the URL of the installation server.
  * URL: ftp://192.168.122.1/inst/ks.cfg
  * Kernel Options: 
    * ks=ftp://192.168.122.1/pub/ks.cfg
    * repo=ftp://192.168.122.1/pub/inst
    * ip=192.168.122.100::192.168.122.1:255.255.255.0:labmachine.example.org:enp1s0:none
  * OS Name: CentOS 8

4. Set the RAM and CPU.

5. Set the harddrive size.

6. Set the name and network. Select Finish.

## Lab 3b

### Question

Using the virt-install command, create a new VM based on the information below.
 Use the lab results from the **Simple HTTP and FTP** lab as the kickstart server.

Resource  | Value
--------- | ----------------------
Name      | labmachine
RAM       | 1536
CPU       | 1
Harddrive | 16 GiB
Network   | insider 
Hostname  | labmachine.example.com
IPv4      | 192.168.122.100

### Answer

```
virt-install --connect qemu:///system \
             --name=labmachine \
             --ram=1536 \
             --vcpus=1 \
             --os-type=linux \
             --os-variant=centos8 \
             --disk path=/var/lib/libvirt/images/outsider1-1.qcow2,size=16 \
             --disk path=/var/lib/libvirt/images/outsider1-2.qcow2,size=2 \
             --disk path=/var/lib/libvirt/images/outsider1-3.qcow2,size=2 \
             --network network=insider \
             --location="ftp://192.168.122.1/pub/inst" \
             --extra-args="ks=ftp://192.168.122.1/pub/ks.cfg" \
             --extra-args="repo=ftp://192.168.122.1/pub/inst" \
             --extra-args="ip=192.168.122.100::192.168.122.1:255.255.255.0:labmachine.example.org:enp1s0:none" \
             --extra-args="dns=192.168.100.1"
```
