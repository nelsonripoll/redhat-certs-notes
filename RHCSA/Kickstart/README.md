# Kickstart
[Red Hat Kickstart Syntax](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-syntax)


## Basic Configuration
```
# system language
lang en_US.UTF-8

# keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# system timezone
timezone America/Chicago --nontp
```


## Installation Method
You must specify whether you are installing or upgrading the system.
```
# install new system
install

# upgrade current system
upgrade
```
You must specify the type of installation from cdrom, harddrive, nfs, liveimg,
 or url (for FTP, HTTP, or HTTPS installations). The **install** command and the 
 installation method command must be on seperate lines. For example:
```
install
liveimg --url=file:///images/install/squashfs.img --noverifyssl
```

Install from the first optical drive on the system.
```
install
cdrom
```
Install from an installation tree or full installation ISO image on a local
 drive. The drive must contain a file system the installation program can mount:
 ext2, ext3, ext4, vfat, or xfs.
*   --biospart= - BIOS partition to install from.
*   --partition= - Partition to install from.
*   --dir= - Directory containing the variant directory of the installation
 tree, or the ISO image of the full installation DVD.
```
# install from tree
install
harddrive --partition=hbd2 --dir=/path/to/dir

# install from iso
install
harddrive --partition=hbd2 --dir=/path/to/file.iso
```
Install from a disk image instead of packages. The image can be the squashfs.img
 file from a live ISO image, a compressed tar file (.tar, .tbz, .tgz, .txz, 
 .tar.bz2, .tar.gz, or .tar.xz), or any file system that the installation media
 can mount. Supported file systems are ext2, ext3, ext4, vfat, and xfs.
*   --url= - The location to install from. Supported protocols are HTTP, HTTPS,
 FTP, and file.
*   --proxy= - Specify an HTTP, HTTPS, or FTP proxy to use while performing the
 installation.
*   --checksum= - An optional argument with the SHA256 checksum of the image
 file, used for verification.
*   --noverifyssl - Disable SSL verification when connecting to an HTTPS server.
```
install
liveimg --url=file:///images/install/squashfs.img --checksum=03825f567f17705100de3308a20354b4d81ac9d8bed4bb4692b2381045e56197 --noverifyssl
```
Install from the NFS server specified.
*   --server= - Server from which to install (host name or IP).
*   --dir= - Directory containing the variant directory of the installation tree.
*   --opts= - Mount options to use for mounting the NFS export. (optional)
```
install
nfs --server=192.168.122.1 --dir=/path/to/dir
```

Install from an installation tree on a remote server using FTP, HTTP, or HTTPS.
*   --url= - The location to install from. Supported protocols are HTTP, HTTPS,
 FTP, and file.
*   --mirrorlist= - The mirror URL to install from.
*   --proxy= - Specify an HTTP, HTTPS, or FTP proxy to use while performing
 the installation.
*   --noverifyssl - Disable SSL verification when connecting to an HTTPS server.
```
install
url --url http://server/path
```


## Boot Loader Options


## Partition Information


## Network Configuration


## Authentication


## Firewall Configuration
Specify the firewall configuration for the installed system.
```
firewall --enabled|--disabled device [options] 
```
*   --enabled or --enable - Reject incoming connections that are not in response
 to outbound requests, such as DNS replies or DHCP requests. If access to
 services running on this machine is needed, you can choose to allow specific
 services through the firewall.
*   --disabled or --disable - Do not configure any iptables rules.
*   --trust= - Listing a device here, such as em1, allows all traffic coming
 to and from that device to go through the firewall. To list more than one
 device, use --trust em1 --trust em2. Do NOT use a comma-seperated format such
 as --trust em1, em2.
*   incoming - Replace with one or more of the following to allow the specified
 services through the firewall.
    * --ssh
    * --smtp
    * --http
    * --ftp
*   --port= - You can specify that ports be allowed through the firewall using
 the port:protocol format. For example, to allow IMAP access through your
 firewall, specify imap:tcp. Numeric ports can also be explicitly; for example,
 to allow UDP packets on port 1234 through, specify 1234:udp. To specify
 multiple ports, separate them by commas.
*   --service= - This option provides a higher-level way to allow services
 through the firewall. Some services (like cups, avahi, and so on) require
 multiple ports to be open or other special configuration in order for the
 service to work. You can specify each individual port with the --port option,
 or specify --service= and open them all at once.

Disabled Firewall
```
firewall --disabled
```

Enabled Firewall Example
```
firewall --enabled --trust em1 --trust em2 --http --ftp --ssh --telnet --smtp --port=9999 --service="https cups avahi"
```

   
## Display Configuration


## Package Selection


## Pre-Installation Script


## Post-Installation Script
