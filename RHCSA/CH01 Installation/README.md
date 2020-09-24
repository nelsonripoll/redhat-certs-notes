# Installation

## Basic Hardware Requirements
CentOS 7 can be installed only on 64-bit systems.

### Architectures
You can install CentOS 7 on systems with a wide variety of 64-bit CPUs.

- Intel/AMD64 (x86\_64)
- IBM POWER7
- IBM System Z

If you're planning to configure VMs on CentOS 7, be sure to choose a system that
 supports hardware-assisted virtualization, along with BIOS or UEFI menu options
 that allow you to activate hardware-assisted virtualization.

If you are currently running a linux system, you should be able to run the
 following command to identify the architecture of a system:

```
# uname -p
```

A configuration that supports hardware-assisted virtualization will have either
 the **vmx** (Intel) or **svm** (AMD) flags in the /proc/cpuinfo file.

### RAM
For basic Intel/AMD-based 64-bit architectures, CentOS 7 requires 1GB of RAM,
 however the graphical installer runs with a minimum of 512MB.

Actual memory requirements depend on the load from every program that may be
 run simultaneously on a system and the memory requires of any VMs that may
 be running on a physical CentOS 7 system.

### Hard Drive
BIOS or UEFI has to recognize the active primary partition before a computer
 can load Linux. This partition should include the Linux boot files.

The GUID Partition Table (GPT) is a partitioning format that requires UEFI 
 firmware over BIOS firmware to boot from. In order to boot from a drive larger
 than 2TB, you need both UEFI and a GPT-partitioned hard drive.

### Virtual Machine Options

#### Application level vs. VM level
Systems such as **Wine Is Not an Emulator** (Wine) support the installation of 
 a single application. In this case, Wine allows an application designed for
 Windows to be installed on Linux. On the other end, VM-level virtualization
 emulates a number of complete computer systems for the installation of seperate
 guest OSs.

#### Hosted vs. bare-metal hypervisor
Applications such as VMware Player and VirtualBox are hosted hypervisors because
 they run on a conventional operating system such as Windows. Conversely,
 bare-metal virtualization systems, such as VMware ESXi and Citrix XenServer,
 include a minimal operating system dedicated to VM operations.

#### Paravirtualization vs full virtualization
Full virtualization allows a guest OS to run unmodified on a hypervisor, whereas
 paravirtualization requires specialized drivers to be installed in the guest OS.

## Download CentOS
You will need to download a copy of CentOS from a 
 [mirror](https://www.centos.org/download/mirrors/) of your choice. The latest
 version of CentOS at the time of writing this is 
 [CentOS-7.6.1810](https://wiki.centos.org/Manuals/ReleaseNotes/CentOS7.1810).

### Download an ISO with cURL
If you chose to download CentOS from the 
 [Linux Kernel Archive](https://www.kernel.org/), you can find the latest
 minimal iso [here](http://mirrors.edge.kernel.org/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso).

```
# curl -O \
  http://mirrors.edge.kernel.org/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso \
  /path/to/iso/location/centos7.iso

# curl -O \
  https://mirrors.edge.kernel.org/centos/7.6.1810/isos/x86_64/sha256sum.txt \
  /path/to/iso/location/checksum.txt
```

The checksum file provides you with the 256-bit Secure Hash Algorithm that
 you can use to check the ISO file against.

```
# sha256sum /path/to/iso/location/centos7.iso
```
