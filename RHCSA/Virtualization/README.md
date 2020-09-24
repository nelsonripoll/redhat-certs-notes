# Virtualization
[Red Hat - Virtualization Getting Started Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_getting_started_guide/index)
## Packages
### Install Group Packages
```
# yum group install "Virtualization Tools" \
                    "Virtualization Hypervisor" \
                    "Virtualization Client"
```
## Kernel Modules
### Determine Kernel Modules Are Loaded
Associated kernel modules must be loaded before KVM can work.  If the KVM modules 
 are properly loaded, you'll see one of the following outputs based on your 
 hardware configuration.
```
# lsmod | grep kvm
```
If you are using an Intel processor:
```
Module    Size    Used by
kvm_intel 12345   0
kvm       12345   1 kvm_intel
```
If you are using an AMD processor:
```
Module    Size    Used by
kvm_amd   12345   0
kvm       12345   1 kvm_amd  
```
### Load Modules
To make sure the processor is suitable, make sure the **vmx** (Intel) or **svm**
 (AMD) flags are loaded.
```
# cat /proc/cpuinfo | grep 'vmx\|svm'
```
If neither flag is found, you may need some additional configuration in the
 system BIOS or UEFI menu.
If one of the flags exists, load the module based on the hardware.
To load the module for an Intel processor:
```
# modprobe kvm_intel
```
To load the module for an AMD processor:
```
# modprobe kvm_amd
```
## Virtual Shell
To connect locally as the root user to the daemon supervising guest virtual
 machines on the KVM hypervisor.
```
# virsh -c qemu:///system
```
To connect locally as a user to the user's set of guest local machines using the
 KVM hypervisor.
```
# virsh -c qemu:///session
```
## virt-install
The **virt-install** is a command line tool used for creating KVM, Xen, or Linux
 container guests using the **libvirt** hypervisor management library. Most
 options are not required. Minimum requirements are **--name**, **--memory**,
 guest storage (**--disk** or **--filesystem**), and an install option.
### Common Options 
| Switch            | Description                                                 |
| ----------------- | ----------------------------------------------------------- |
| --connect         | Connect to a non-default hypervisor.                        |
| --name            | Sets the name for the VM.                                   |
| --vcpus           | Configures the number of virtual CPUs.                      |
| --memory          | Memory to allocate for the guest, in MiB.                   |
| --disk            | Defines the virtual disk.                                   |
| --location        | Specifies the directory or URL with the installation files. |
| --graphics        | Specifies the graphical display settings of the guest.      |
| --extra-args      | Includes extra data, such as the URL of a Kickstart file.   |
#### --connect
Connect to a non-default hypervisor. If this isn't specified, libvirt will try 
 and choose the most suitable default.

Some valid options here are:
##### qemu:///system
For creating KVM and QEMU guests to be run by the system libvirtd instance.
 This is the default mode that virt-manager uses, and what most KVM users want.
```
# virt-install --connect qemu:///system [OPTIONS]...
```
##### qemu:///session
For creating KVM and QEMU guests for libvirtd running as the regular user.
```
# virt-install --connect qemu:///session [OPTIONS]...
```
##### xen:///
For connecting to Xen.
```
# virt-install --connect xen:/// [OPTIONS]...
```
##### lxc:///
For creating linux containers.
```
# virt-install --connect lxc:/// [OPTIONS]...
```
#### --name
Name of the new guest virtual machine instance. This must be unique amongst all 
 guests known to the hypervisor on the connection, including those not currently 
 active. To re- define an existing guest, use the virsh(1) tool to shut it down 
 ('virsh shutdown') & delete ('virsh undefine') it prior to running "virt-install".
#### --vcpus
Number of virtual cpus to configure for the guest. 
```
# virt-install --vcpus 2 [OPTIONS]...
```
If 'maxvcpus' is specified, the guest will be able to hotplug up to MAX vcpus 
 while the guest is running, but will startup with VCPUS.
```
# virt-install --vcpus 2,maxvcpus=4 [OPTIONS]...
```
If 'cpuset' is set, the guest is told which physical cpus it can use. 'cpuset' 
 is a comma separated list of numbers, which can also be specified in ranges or 
 cpus to exclude.

Use processors 1,2,4,5 and 8:
```
# virt-install --vcpus 2,cpuset=1-5,^3,8 [OPTIONS]...
```
Use processors 0,2,3 and 5 with 'maxvcpus' set:
```
# virt-install --vcpus 2,maxvcpus=4,cpuset=0,2,3,5 [OPTIONS]...
```
#### --memory
Memory to allocate for the guest, in MiB. This deprecates the -r/--ram option.
 Sub options are available, like 'maxmemory', 'hugepages', 'hotplugmemorymax' 
 and 'hotplugmemoryslots'.
#### --disk
Specifies media to use as storage for the guest, with various options. 

The general format of a disk string is:
```
# virt-install --disk opt1=val1,opt2=val2,... [OPTIONS]...
```
#### --location
Distribution tree installation source. virt-install can recognize certain distribution 
 trees and fetches a bootable kernel/initrd pair to launch the install.
#### --graphics
Specifies the graphical display configuration. This does not configure any virtual 
 hardware, just how the guest's graphical display can be accessed. Typically the 
 user does not need to specify this option, virt-install will try and choose a 
 useful default, and launch a suitable connection.

General format of a graphical string is:
```
# virt-install --graphics TYPE,opt1=arg1,opt2=arg2,... [OPTIONS]...
```
#### --extra-args
Additional kernel command line arguments to pass to the installer when performing 
 a guest install from "--location".
### Examples
Install a Fedora 9 plain QEMU guest, using LVM partition, virtual networking, 
 booting from PXE, using VNC server/viewer, with virtio-scsi disk:
```
# virt-install \
     --connect qemu:///system \
     --name demo \
     --memory 500 \
     --disk path=/dev/HostVG/DemoVM,bus=scsi \
     --controller virtio-scsi \
     --network network=default \
     --virt-type qemu \
     --graphics vnc \
     --os-variant fedora9
```
Run a Live CD image under Xen fullyvirt, in diskless environment:
```
# virt-install \
     --hvm \
     --name demo \
     --memory 500 \
     --disk none \
     --livecd \
     --graphics vnc \
     --cdrom /root/fedora7live.iso
```
Run /usr/bin/httpd in a linux container guest (LXC). Resource usage is capped at 
512 MiB of ram and 2 host cpus:
```
# virt-install \
      --connect lxc:/// \
      --name httpd_guest \
      --memory 512 \
      --vcpus 2 \
      --init /usr/bin/httpd
```
Start a linux container guest(LXC) with a private root filesystem, using /bin/sh 
 as init. Container's root will be under host dir /home/LXC. The host dir "/home/test" 
 will be mounted at "/mnt" dir inside container:
```
# virt-install \
      --connect lxc:/// \
      --name container \
      --memory 128 \
      --filesystem /home/LXC,/ \
      --filesystem /home/test,/mnt \
      --init /bin/sh
```
Install a paravirtualized Xen guest, 500 MiB of RAM, a 5 GiB of disk, and Fedora 
 Core 6 from a web server, in text-only mode, with old style --file options:
```
# virt-install \
     --paravirt \
     --name demo \
     --memory 500 \
     --disk /var/lib/xen/images/demo.img,size=6 \
     --graphics none \
     --location http://download.fedora.redhat.com/pub/fedora/linux/core/6/x86_64/os/
```
Create a guest from an existing disk image 'mydisk.img' using defaults for the 
 rest of the options.
```
# virt-install \
     --name demo \
     --memory 512 \
     --disk /home/user/VMs/mydisk.img \
     --import
```
Start serial QEMU ARM VM, which requires specifying a manual kernel.
```
# virt-install \
     --name armtest \
     --memory 1024 \
     --arch armv7l --machine vexpress-a9 \
     --disk /home/user/VMs/myarmdisk.img \
     --boot kernel=/tmp/my-arm-kernel,initrd=/tmp/my-arm-initrd,dtb=/tmp/my-arm-dtb,kernel_args="console=ttyAMA0 rw root=/dev/mmcblk0p3" \
     --graphics none
```
If you make a mistake, you can abort the process with **CTRL-C**. The newly created
 VM is still running and would need to be destroyed before you can use the same
 name.
Stop the VM:
```
# virsh destroy guest-name
```
Delete the associated XML configuration file:
```
# virsh undefine guest-name --remove-all-storage
```
Now you'll be able to run the **virt-install** command again with the same name
 for the VM.
## virsh
| Subcommand         | Description                                                            |
| ------------------ | ---------------------------------------------------------------------- |
| capabilities       | Lists the abilities of the local hypervisor.                           |
| list --all         | Lists all domains.                                                     |
| autostart <domain> | Configures a domain to be started during the host system boot process. |
| edit <domain>      | Edits the XML configuration file for the domain.                       |
| start <domain>     | Boots the given domain.                                                |
| shutdown <domain>  | Gracefully shuts down the given domain.                                |
| destroy <domain>   | Immediately terminate the given domain.                                |
| undefine <domain>  | Undefine the given domain.                                             |
## virt-clone
