# Labs

| System    | Hostname              | Network          | IP              |
| --------- | --------------------- | ---------------- | --------------- |
| server1   | server1.example.com   | 192.168.122.0/24 | 192.168.122.50  |
| tester1   | tester1.example.com   | 192.168.122.0/24 | 192.168.122.150 |
| outsider1 | outsider1.example.org | 192.168.100.0/24 | 192.168.100.100 |

## Lab 1
In this lab, you will install RHEL to create a basic server on a KVM-based VM.
 You will need sufficient room for one hard disk of at least 16GB (with 
 sufficient space for 11GB of data plus a swap partition, assuming at least 
 512MB of spare RAM for the VM). You’ll also need room for an additional two 
 virtual hard drives of 1GB each (18GB total). 

The steps in this lab assume an installation on a KVM-based VM. To start the 
 process, open a GUI and run the virt-manager command.  If it doesn’t happen 
 automatically, right-click the Localhost (QEMU) option and click Connect in 
 the pop-up menu that appears. Enter the root administrative password if 
 prompted to do so. Once connected, you can then right-click the same option 
 and then click New. This starts the wizard that helps configure a VM. 

If you’re configuring the actual VMs to be used in future chapters, this will 
 be the server1.example.com system discussed in Chapter 1. 

Ideally, there will be sufficient space on your main machine for at least four 
 different virtual systems of the given size. That includes the three systems 
 specified in Chapter 1, plus one spare. In other words, a logical volume or 
 partition with 75GB of free space would be (barely) sufficient. 

The steps described in this lab are general. By this time, you should have some 
 experience with the installation of RHEL 7. In any case, the exact steps vary 
 with the type of installation and the boot media:

1. Start with the RHEL 7 network boot CD or the installation DVD.

2. Based on the steps discussed in Chapter 1, start the installation process 
 for RHEL 7.

3. From the Installation Summary screen, select Installation Source and point 
 the system to the FTP-based installation server created in Chapter 1. If you 
 followed the directions in that chapter, the server will be on 
 ftp://192.168.122.1/pub/inst.

4. From the Installation Summary screen, click Installation Destination and 
 select custom partitioning.

5. Create the first partition of about 500MB of disk space, formatted to the 
 xfs filesystem, and assign it to the /boot directory.

6. Create the next partition with 1GB of disk space (or more, if space is 
 available), reserved for swap space.

7. Create a third partition with about 10GB disk space, formatted to the xfs 
 filesystem, and assign it to the top-level root directory, /.

8. Create another partition with about 1GB of disk space and assign it to the 
 /home directory.

9. From the Installation Summary screen, set up the local system on a network 
 configured on the KVM hypervisor. The default is the 192.168.122.0/24 network; 
 for the server1.example.com system, this will be on IP address 192.168.122.50 
 and gateway 192.168.122.1. Configure the hostname server1.example.com.

10. From the Installation Summary screen, click Software Selection and then 
 select Server with GUI. Installation of virtualization packages within a VM is 
 not required.

11. Continue with the installation process, using your best judgment.

12. Reboot when prompted and log in as the root user. Run the poweroff command 
 when you’re ready to finish this lab.


## Lab 2

In this lab, you'll clone the system created in Lab 1. Use the techniques 
 discussed in this chapter to clone that system. The process can be completed 
 either at the command line with the virt-clone command or with the Virtual 
 Machine Manager.

In addition, when rebooting the system, you'll want to set this system up as 
 the clone1.example.org system on the 192.168.100.50 IP address. You can 
 substitute a different IP address as long as it's on a different network from 
 the server1.example.com system.

When a system is cloned, it carries everything from the previous system. So the 
 first time you boot a cloned system, it's best to boot it into the rescue 
 target, which does not start networking. For more information on systemd 
 targets and network configuration, see Chapters 3 and 5.


## Lab 3

Use the virt-install command to create a new system. Use the model described in 
 Chapter 1 for the tester1.example.com system, with an IP address of 
 192.168.122.150.


## Lab 4

In this lab, you'll modify the Kickstart file created on the server1.example.com 
 VM in Lab 1. It's the anaconda-ks.cfg file in the root user's home directory. 
 That file will be used to automate the installation of a system on a virtual 
 machine. Unless you've already created it, the system will be 
 tester1.example.com on IP address 192.168.122.150. If you've set up the 
 server1.example.com system on a different network, make sure the 
 tester1.example.com system is on the same network. Remember the lessons of the 
 chapter when modifying that file. Here are a few hints:

1. Change the network directive to set the new system to an appropriate IP 
 address and hostname.

2. Make sure the partition directives are active (uncommented). Change them as 
 needed to make sure a size is specified.

3. Configure the system to shut down after installation is complete.

4. Don't be afraid of some trial and error. If the installation stops during the 
 process, check the messages in different virtual consoles (see point 11).

5. Copy the Kickstart file to the installation directory created in Chapter 1. 
 Use the techniques discussed in that chapter to make sure the Kickstart file 
 matches the SELinux context of other files in that directory and ensure it is 
 readable by all users.

6. Create a new KVM-based VM, using the techniques discussed in the chapter.

7. Boot the system from the RHEL 7 network boot CD.

8. At the boot screen, highlight the Install Red Hat Enterprise Linux 7.0 option 
 and press tab.

9. Add the ks directive along with the URL of the network installation source 
 created in Chapter 1.

10. Press enter. The installation should now proceed to completion, without 
 intervention.

11. If the installation stops during the process, make notes on where it 
 stopped. The screens available during the installation process can help. To 
 access those screens, press ctrl-alt-f3, ctrl-alt-f4, and ctrl-alt-f5. To 
 return to the main installation screen, press alt-f6 (alt-f1 if you're using 
 the text-based installation program).

12. Match the stopping point with the appropriate entry in the Kickstart 
 configuration file.

13. Modify the Kickstart configuration file, and rerun the Kickstart-based 
 installation.


## Lab 5

In this lab, you'll modify the Kickstart file created on the server1.example.com 
 VM in Labs 1 and 4, for use by the virt-install command. Unless you've already 
 created it, the system will be outsider1.example.org on IP address 
 192.168.100.100. (If that IP address network is in use by another component 
 such as a cable modem, another IP address such as 192.168.101.100 is 
 acceptable.)


## Lab 6

In this lab, you'll test a Secure Shell client on any and all virtual machines 
 that you've created. Hopefully, you'll remember the root administrative 
 password configured during the installation process.

1. To see how the system works, first run the following command on the local 
 system (if desired, substitute 127.0.0.1 for localhost):

```
# ssh localhost
```

2. Proceed with the login to the localhost system. Log out with the exit 
 command.

3. Review the current known hosts for the system with the cat ~/.ssh/known_hosts 
 command. The file may appear incomprehensible, but you'll see a line such as 
 the following near the end of the file, which refers to the public RSA key 
 from the localhost system:

```
localhost ecdsa-sha2-nistp256 AAAAE2VjZHNhL...
```

4. Repeat the process with a remote system such as server1.example.com, or the 
 equivalent IP address such as 192.168.122.50. After returning to the local 
 system, what do you see added to the known_hosts file? (Direct connections to 
 the server1.example.com system may not work until you've set up the /etc/hosts 
 file as discussed in Chapter 3.)

5. This step requires access to the GUI on a local system and GUI applications 
 on the remote system. If you've followed the instructions so far in Chapters 1 
 and 2, you'll have a number of systems that meet these requirements. With that 
 in mind, log in to the noted remote system from a local GUI-based terminal with 
 the following command (substitute an appropriate hostname or IP address as 
 needed):

```
# ssh -X root@192.168.122.50
```

6. Now try to open a GUI application on the remote system, perhaps even the 
 Firefox web browser (if that's installed) with the firefox command. To confirm 
 success, look at the title bar of the window that appears. It should display a 
 message with the location of the remote application, such as the following:

Welcome to Firefox - Mozilla Firefox (on server1.example.com)

7. Exit from the remote application and then exit from the remote system.


## Lab 7

In this lab, you'll perform three tasks associated with one of the VMs created 
 in previous labs:

*   Start a VM from the command line.
*   Stop a VM from the command line. 
*   Configure that VM from the command line.

You may recognize these tasks from the RHCSA objectives. The process should be 
 fairly simple. First, take account of currently configured VMs with the 
 following command:

```
# virsh list --all
```

From the VMs that appear in the output, pick one that isn't currently running. 
 If the server1.example.com system is not running, start it. Confirm that it is 
 currently running. Use the ssh command to access a remote console on that VM 
 system.

Now from the command line of the host physical system, stop that virtual 
 console. What command actually performs the task? Confirm the result with the 
 virsh list --all command.

If you want to set up the server1.example.com system to start automatically 
 during the boot process, run the following command:

```
# virsh autostart server1.example.com
```

To confirm the change, review the contents of the /etc/libvirt/qemu/autostart 
 directory. Next, enter the VM system and run the ip addr show command to 
 confirm the IP address of that VM's network card. If you've configured this 
 particular server1.example.com system per the instructions discussed in 
 Chapter 1, that IP address should be 192.168.122.50.

Now power down any currently running VMs, and reboot the physical host system. 
 When the system boots again, log in to the local host system. Don't start 
 Virtual Machine Manager. Run the ssh commands described in Lab 6. If it works, 
 then you should be able to connect to the VM as if it were a remote system.

Exit from the remote system and run the virsh list --all command. You should 
 see output similar to the following:

```
 Id    Name                           State
----------------------------------------------------
 2     server1.example.com            running
```

Now power down the remote system. You can ssh again into the remote system and 
 run the poweroff command directly from there. How do you reverse the process, 
 so this system does not start the next time you reboot the physical host system?


## Lab 8

In this lab, you'll use the commands described at the end of Chapter 2 to test 
 connections to available services. If you've created the network installation 
 servers described in Chapter 1, there will be at least FTP and HTTP servers 
 active on those systems. The default ports for these services are 21 and 80, 
 respectively. Try the telnet localhost 21 command on a local system, where the 
 vsFTP service is active. Look at the following output:

```
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
220 (vsFTPd 3.0.2)
```

Now exit from the telnet session. Confirm the IP address of the local system 
 with the ip addr show dev virbr0 command. It should be an address such as 
 192.168.122.1. Log in to a remote VM such as tester1.example.org with a command 
 such as ssh root@192.168.122.150. Now try the same command again from that 
 remote system; for example, for the server1.example.com system on IP address 
 192.168.122.50, run the following command:

```
# telnet 192.168.122.50 21
```

Do you get a "connection refused" or a "no route to host" message? What do each 
 of those messages mean? It's acceptable if you're not certain about how to 
 address this issue now, as firewalls are not covered until Chapter 4.

Now try nmap on the local system with the following command:

```
# nmap localhost
```

From the tester1.example.com system, review what other systems on the local 
 network can see from the following command. Pay attention to the differences. 
 That will give you hints on what services are blocked by firewalls. Those 
 firewalls may go beyond what's configured with the firewall-cmd command 
 discussed in Chapter 4.

```
# nmap 192.168.122.50
```

# Lab Answers

## Lab 1
Although there is nothing truly difficult about this lab, it should increase 
 your confidence with VMs based on KVM. Once it’s complete, you should be able 
 to log in to the VM as the root administrative user and run the following 
 checks on the system: 

1. Check mounted filesystems, along with the space available. The following 
 commands should confirm those filesystems that are mounted, along with the 
 free space available on the associated volumes:
 ```
 # mount
 # df -m
 ```

2. Assuming you have a good connection to the Internet and a subscription to 
 the Red Hat Portal, make sure the system is up to date. If you’re using a 
 rebuild distribution, access to their public repositories is acceptable. In 
 either case, run the following command to make sure the local system is up to 
 date:
 ```
 # yum update
 ```

This lab confirms your ability to “install Red Hat Enterprise Linux systems as 
 virtual guests.”


## Lab 2
Remember, this and all future labs in this book can be found on the DVD that 
 comes with this book. Labs 2 through 8 can be found in the Chapter2/ 
 subdirectory of that DVD.  

One of the issues with system cloning is how it includes the hardware MAC 
 address of any network cards. Such conflicts can lead to problems on a network. 
 So not only would you have to change the IP address, but you may also need to 
 ensure that a unique hardware address is assigned to the given virtual network 
 adapter. Because of such issues, KVM normally sets up a different hardware MAC 
 address for a cloned system. For example, if the original system had an eth0 
 network card with one hardware address, the cloned system would have a network 
 card with a different hardware address. 

If this seems like too much trouble, feel free to delete the cloned system. 
 After all, there is no reference to VM cloning in the RHCSA requirements. 
 However, it may be helpful to have a different backup system.  And that’s an 
 excellent opportunity to practice the skills gained in Lab 4 with Kickstart 
 installations.  

## Lab 3

If you haven’t yet set up the four different VMs suggested in Chapter 1 (three 
 VMs and a backup), this is an excellent opportunity to do so. One way to do 
 this is with the virt-install command. Specify the following information: 
*  Allocated RAM ( --ram) in megabytes, which should be at least 512.  
*  The path to the virtual disk file ( --disk), which could be the same as that 
 virtual disk created in Lab 2, and its size in gigabytes, if that file doesn’t 
 already exist.  
*  The URL ( --location) for the FTP installation server created in Chapter 1, 
 Lab 2. Alternatively, you could use the HTTP installation server also discussed 
 in Chapter 1.  
*  The OS type (--os-type= linux) and variant (--os-variant= rhel7).

You can now complete this installation normally or run a variation of that installation in Lab 5.


## Lab 4
If you’re not experienced with Kickstart configuration, some trial and error 
 may be required. But it’s best to run into problems now and not during a Red 
 Hat exam or on the job. If you’re able to set up a Kickstart file that can be 
 used to install a system without intervention, you’re ready to address this 
 challenge on the RHCSA exam.  One common problem relates to virtual disks that 
 have just been created. They must be initialized first; that’s the purpose of 
 the --initlabel switch to the clearpart directive.


## Lab 5
If you’ve recently run a Kickstart installation for the first time, it’s best 
 to do it again. If you practice now, it means you’ll be able to set up a 
 Kickstart installation faster during an exam. And that’s just the beginning.
 Imagine the confidence you’ll have if your boss needs a couple of dozen VMs 
 with the same software and volumes. Assuming the only differences are hostname 
 and network settings, you’ll be able to accomplish this task fairly quickly.
 If you can set up a Kickstart installation from the command line with the 
 virt-install command, it’ll be a lot easier to set it up on a remote virtual 
 host. You’ll be able to configure new systems from remote locations, thus 
 increasing your value in the workplace. If you haven’t yet set up the four VMs 
 suggested in Chapter 1 (three as test systems, one as a backup), this is your 
 opportunity to do so.  tall , you’ll need to use regular command switches. As 
 you’re not allowed to bring this book into an exam, try to perform this lab 
 without referring to the main body of this chapter. You’ll be able to refer to 
 the man page for the virt-install command for all of the important switches. 
 Be sure to put the ks= directive along with the URL of the Kickstart file 
 within quotes. Success is the installation of a new system.


## Lab 6
This lab is designed to increase your understanding of the use of the ssh 
 command as a client. The encryption performed should be transparent, and will 
 not affect any commands used through an SSH connection to administer remote 
 systems.


## Lab 7
This lab is somewhat critical with respect to several different RHCSA 
 objectives. Once you understand the process, the actual tasks are deceptively 
 simple. After completing this lab, you should have confidence in your abilities 
 to do the following: 
*   Start and stop virtual machines.  
*   Configure systems to launch virtual machines at boot.  
The lab also suggests one method for remotely accessing a VM.


## Lab 8
This lab is designed to increase your familiarity with two important network 
 troubleshooting tools, telnet and nmap . Network administrators with some 
 Linux experience may prefer other tools. If you’re familiar with other tools 
 such as nc , great. It’s the results that matter.
