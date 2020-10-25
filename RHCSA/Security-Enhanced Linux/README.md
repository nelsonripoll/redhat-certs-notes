# Security-Enhanced Linux

Security-Enhanced Linux (SELinux) was developed by the U.S. National Security 
 Agency to provide a level of mandatory access control for Linux. It enforces 
 security rules within the kernel of the operating system.

SELinux is a set of security rules that determine which process can access which 
 files, directories, and ports. Every file, process, directory, and port has a 
 special security label called a SELinux context. A context is a name that is 
 used by the SELinux policy to determine whether a process can access a file, 
 directory, or port.

## SELinux Status

There are three available modes for SELinux: **enforcing**, **permissive**, and
 **disabled**. The **enforcing** and **disabled** modes are self-explanatory.
 SELinux in **permissive** mode means that any SELinux rules that are violated
 are logged, but the violation does not stop any action.

If you want to change the default SELinux mode, change the **SELINUX** directive
 in the **/etc/selinux/config** file. The next time you reboot, the changes are
 applied to the system.

If SELinux is configured in **enforcing** mode, it protects the systems in one
 of two ways: in **targeted** mode or in **mls** (multi-level security) mode. 
 The default is the **targeted** policy, which allows you to customize what is 
 protected by SELinux.  In contrast, **mls** goes a step further, using the 
 Bell-La Padula model developed for the US Department of Defense. That model, 
 as suggested in the **/etc/selinux/targeted/setrans.conf** file, supports 
 layers of security between levels c0 and c3. Although the c3 level is listed 
 as "Top Secret", the range of available levels goes all the way up to c1023. 
 If you want to explore **mls**, install the **selinux-policy-mls** RPM.

There are some essential commands that can be used to review and configure basic
 SELinux settings. To see the current status of SELinux, run the ```getenforce```
 command; it should return one of the three statuses: **Enforcing**, **Permissive**,
 or **Disabled**. The ```sestatus``` command provides more information:

```
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      31
```

If SELinux is disabled, the output would be:

```
SELinux status:    disabled
```

You can change the current SELinux status with the ```setenforce``` command:

```
# setenforce enforcing
# setenforce permissive
```

If SELinux is disabled, you have to manually change the **SELINUX** variable in
 the **/etc/selinux/config** file and reboot the system to "relabel" all files.

## SELinux Booleans

SELinux Booleans are rules that can be enabled or disabled and change the
 behavior of the SELinux policy. The ```getsebool``` command is used to display
 SELinux Booleans and their current value. The **-a** option causes this command
 to list all of the Booleans. For example, to list all of the **httpd** booleans, 
 run ```getsebool -a | grep httpd```.

```
httpd_can_connect_ftp --> off
httpd_can_connect_ldap --> off
httpd_can_connect_mythtv --> off
httpd_can_connect_zabbix --> off
httpd_can_network_connect --> off
httpd_can_network_connect_cobbler --> off
httpd_can_network_connect_db --> off
httpd_can_network_memcache --> off
httpd_can_network_relay --> off
httpd_can_sendmail --> off
httpd_dbus_avahi --> off
httpd_dbus_sssd --> off
httpd_dontaudit_search_dirs --> off
httpd_enable_cgi --> on
httpd_enable_ftp_server --> off
httpd_enable_homedirs --> off
httpd_execmem --> off
httpd_graceful_shutdown --> off
httpd_manage_ipa --> off
httpd_mod_auth_ntlm_winbind --> off
httpd_mod_auth_pam --> off
httpd_read_user_content --> off
httpd_run_ipa --> off
httpd_run_preupgrade --> off
httpd_run_stickshift --> off
httpd_serve_cobbler_files --> off
httpd_setrlimit --> off
httpd_ssi_exec --> off
httpd_sys_script_anon_write --> off
httpd_tmp_exec --> off
httpd_tty_comm --> off
httpd_unified --> off
httpd_use_cifs --> off
httpd_use_fusefs --> off
httpd_use_gpg --> off
httpd_use_nfs --> off
httpd_use_opencryptoki --> off
httpd_use_openstack --> off
httpd_use_sasl --> off
httpd_verify_dns --> off
```

Another way to view a list of SELinux booleans is with the ```semanage boolean -l```
 command. This will list the booleans, if they are on or off, if it is persistent, 
 and a short description. Again, to see all of the **httpd** booleans,
 ```semanage boolean -l | grep httpd```:

```
awstats_purge_apache_log_files     (off  ,  off)  Determine whether awstats can purge httpd log files.
httpd_anon_write                   (off  ,  off)  Allow Apache to modify public files used for public file transfer services. Directories/Files must be labeled public_content_rw_t.
httpd_builtin_scripting            (on   ,   on)  Allow httpd to use built in scripting (usually php)
httpd_can_check_spam               (off  ,  off)  Allow http daemon to check spam
httpd_can_connect_ftp              (on   ,  off)  Allow httpd to act as a FTP client connecting to the ftp port and ephemeral ports
httpd_can_connect_ldap             (off  ,  off)  Allow httpd to connect to the ldap port
httpd_can_connect_mythtv           (off  ,  off)  Allow http daemon to connect to mythtv
httpd_can_connect_zabbix           (off  ,  off)  Allow http daemon to connect to zabbix
httpd_can_network_connect          (off  ,  off)  Allow HTTPD scripts and modules to connect to the network using TCP.
httpd_can_network_connect_cobbler  (off  ,  off)  Allow HTTPD scripts and modules to connect to cobbler over the network.
httpd_can_network_connect_db       (off  ,  off)  Allow HTTPD scripts and modules to connect to databases over the network.
httpd_can_network_memcache         (off  ,  off)  Allow httpd to connect to memcache server
httpd_can_network_relay            (off  ,  off)  Allow httpd to act as a relay
httpd_can_sendmail                 (off  ,  off)  Allow http daemon to send mail
httpd_dbus_avahi                   (off  ,  off)  Allow Apache to communicate with avahi service via dbus
httpd_dbus_sssd                    (off  ,  off)  Allow Apache to communicate with sssd service via dbus
httpd_dontaudit_search_dirs        (off  ,  off)  Dontaudit Apache to search dirs.
httpd_enable_cgi                   (on   ,   on)  Allow httpd cgi support
httpd_enable_ftp_server            (off  ,  off)  Allow httpd to act as a FTP server by listening on the ftp port.
httpd_enable_homedirs              (off  ,  off)  Allow httpd to read home directories
httpd_execmem                      (off  ,  off)  Allow httpd scripts and modules execmem/execstack
httpd_graceful_shutdown            (off  ,  off)  Allow HTTPD to connect to port 80 for graceful shutdown
httpd_manage_ipa                   (off  ,  off)  Allow httpd processes to manage IPA content
httpd_mod_auth_ntlm_winbind        (off  ,  off)  Allow Apache to use mod_auth_ntlm_winbind
httpd_mod_auth_pam                 (off  ,  off)  Allow Apache to use mod_auth_pam
httpd_read_user_content            (off  ,  off)  Allow httpd to read user content
httpd_run_ipa                      (off  ,  off)  Allow httpd processes to run IPA helper.
httpd_run_preupgrade               (off  ,  off)  Allow Apache to run preupgrade
httpd_run_stickshift               (off  ,  off)  Allow Apache to run in stickshift mode, not transition to passenger
httpd_serve_cobbler_files          (off  ,  off)  Allow HTTPD scripts and modules to server cobbler files.
httpd_setrlimit                    (off  ,  off)  Allow httpd daemon to change its resource limits
httpd_ssi_exec                     (off  ,  off)  Allow HTTPD to run SSI executables in the same domain as system CGI scripts.
httpd_sys_script_anon_write        (off  ,  off)  Allow apache scripts to write to public content, directories/files must be labeled public_rw_content_t.
httpd_tmp_exec                     (off  ,  off)  Allow Apache to execute tmp content.
httpd_tty_comm                     (off  ,  off)  Unify HTTPD to communicate with the terminal. Needed for entering the passphrase for certificates at the terminal.
httpd_unified                      (off  ,  off)  Unify HTTPD handling of all content files.
httpd_use_cifs                     (off  ,  off)  Allow httpd to access cifs file systems
httpd_use_fusefs                   (off  ,  off)  Allow httpd to access FUSE file systems
httpd_use_gpg                      (off  ,  off)  Allow httpd to run gpg
httpd_use_nfs                      (off  ,  off)  Allow httpd to access nfs file systems
httpd_use_opencryptoki             (off  ,  off)  Allow httpd to use opencryptoki
httpd_use_openstack                (off  ,  off)  Allow httpd to access openstack ports
httpd_use_sasl                     (off  ,  off)  Allow httpd to connect to  sasl
httpd_verify_dns                   (off  ,  off)  Allow Apache to query NS records
```

To modify SELinux Booleans, use the ```setsebool``` command and use the **-P**
 flag to make the changes permanent or else it will reset after a reboot.

```
# getsebool httpd_can_connect_ftp
httpd_can_connect_ftp --> on
# setsebool httpd_can_connect_ftp off
# getsebool httpd_can_connect_ftp
httpd_can_connect_ftp --> off
# semanage boolean -l | grep httpd_can_connect_ftp 
httpd_can_connect_ftp          (off  ,  off)  Allow httpd to act as a FTP client connecting to the ftp port and ephemeral ports
# setsebool -P httpd_can_connect_ftp on
# semanage boolean -l | grep httpd_can_connect_ftp 
httpd_can_connect_ftp          (on   ,   on)  Allow httpd to act as a FTP client connecting to the ftp port and ephemeral ports
```

To only list local modifications (any settings that differs from the default
 policy), use the command ```semanage boolean -l -C```:

```
SELinux boolean                State  Default Description

httpd_can_connect_ftp          (on   ,   on)  Allow httpd to act as a FTP client connecting to the ftp port and ephemeral ports
virt_sandbox_use_all_caps      (on   ,   on)  Allow sandbox containers to use all capabilities
virt_use_nfs                   (on   ,   on)  Allow confined virtual guests to manage nfs files
```

## SELinux Contexts

SELinux labels have several contexts: user, role, type, and sensitivity. The
 targeted policy, which is the default policy enabled in RHEL, bases its rules
 on the type context. Type context names usually end with **\_t**. The type 
 context for the web server is **httpd\_t**. The type context for files and
 directories normally found in **/var/www/html** is **httpd\_sys\_content\_t**.
 The type contexts for files and directories normally found in **/tmp** and
 **/var/tmp** is **tmp\_t**. The type context for web server ports is 
 **http\_port\_t**.

There is a policy rule that permits the web server process running as **httpd\_t**
 to access files and directories with a context normally found in **/var/www/html**
 and other web server directories (**httpd\_sys\_content\_t**). There is no allow
 rule in the policy for files normally found in **/tmp** and **/var/tmp**, so
 access is not permitted. With SELinux, a malicious user could not access the
 **/tmp** directory. 

The SELinux context of a file's parent directory determines its initial SELinux
 context. The context of the parent directory is assigned to the newly created
 file. This works for commands like ```vim```, ```cp```, and ```touch```. However, 
 if a file is created elsewhere and the permissions are preserved (as with ```mv```
 or ```cp -a```), the original SELinux context will be unchanged.

The ```chcon``` command changes the context of the file to the context specified 
 as an argument to the command. Often the **-t** option is used to specify only 
 the type component of the context. This is only temporary however, as the
 original context would be restored if you run ```restorecon``` or relabel your
 system.

The ```restorecon``` command is the preferred method for changing the SELinux
 context of a file or directory. Unlike ```chcon```, the context is not specified
 when using this command. It uses rule in the SELinux policy to determine what
 the context of the file should be.

The ```semanage fcontext``` command can be used to display or modify the rules
 that the ```restorecon``` command uses to set default file contexts. It uses
 regular expressions to specify the path and file names. The most common extended
 regular expression used in **fcontext** rules is **(/.*)?**, which will match
 the directory listed before the expression and everything in that directory 
 recursively.

The ```restorecon``` command is part of the **policycoreutil** package, and
 ```semanage``` is part of the **policycoreutil-python** package.

```
# ls -lZ /var/ftp
drwxr-xr-x. 3 root root system_u:object_r:public_content_t:s0 32 Sep 23 15:19 pub
# touch /tmp/file1 /tmp/file2
# ls -lZ /tmp/file*
-rw-r--r--. 1 nripoll nripoll unconfined_u:object_r:user_tmp_t:s0 0 Oct 22 09:23 /tmp/file1
-rw-r--r--. 1 nripoll nripoll unconfined_u:object_r:user_tmp_t:s0 0 Oct 22 09:23 /tmp/file2
# mv /tmp/file1 /var/ftp/pub
# cp /tmp/file2 /var/ftp/pub
# ls -lZ /var/ftp/pub/file*
-rw-r--r--. 1 nripoll nripoll unconfined_u:object_r:user_tmp_t:s0       0 Oct 22 09:23 /var/ftp/pub/file1
-rw-r--r--. 1 root    root    unconfined_u:object_r:public_content_t:s0 0 Oct 22 09:27 /var/ftp/pub/file2
# sudo semanage fcontext -l | grep "/var/ftp"
/var/ftp(/.*)?                                     all files          system_u:object_r:public_content_t:s0 
/var/ftp/bin(/.*)?                                 all files          system_u:object_r:bin_t:s0 
/var/ftp/etc(/.*)?                                 all files          system_u:object_r:etc_t:s0 
/var/ftp/lib(/.*)?                                 all files          system_u:object_r:lib_t:s0 
/var/ftp/lib/ld[^/]*\.so(\.[^/]*)*                 regular file       system_u:object_r:ld_so_t:s0 
# restorecon -Rv /var/ftp
Relabeled /var/ftp/pub/file1 from unconfined_u:object_r:user_tmp_t:s0 to unconfined_u:object_r:public_content_t:s0
# ls -lZ /var/ftp/pub/file*
-rw-r--r--. 1 nripoll nripoll unconfined_u:object_r:public_content_t:s0 0 Oct 22 09:23 /var/ftp/pub/file1
-rw-r--r--. 1 root    root    unconfined_u:object_r:public_content_t:s0 0 Oct 22 09:27 /var/ftp/pub/file2
```

```
# mkdir /virtual
# touch /virtual/index.html
# ls -lZd /virtual
drwxr-xr-x. 2 root root unconfined_u:object_r:default_t:s0 24 Oct 22 09:32 /virtual
# ls -lZ /virtual
-rw-r--r--. 1 root root unconfined_u:object_r:default_t:s0 0 Oct 22 09:32 index.html
# semanage fcontext -z -t httpd_sys_content_t '/virtual(/.*)?'
# sudo restorecon -RFvv /virtual
Relabeled /virtual from unconfined_u:object_r:default_t:s0 to system_u:object_r:httpd_sys_content_t:s0
Relabeled /virtual/index.html from unconfined_u:object_r:default_t:s0 to system_u:object_r:httpd_sys_content_t:s0
# ls -lZd /virtual
drwxr-xr-x. 2 root root system_u:object_r:httpd_sys_content_t:s0 24 Oct 22 09:32 /virtual
# ls -lZ /virtual
-rw-r--r--. 1 root root system_u:object_r:httpd_sys_content_t:s0 0 Oct 22 09:32 index.html
```

## Troubleshooting SELinux 

There is a sequence of steps that should be taken if SELinux prevents access to
 files on a server:

1. Before thinking of making any adjustments, consider that SELinux may be doing
 its job correctly by prohibiting the attempted access. If a web server tries to
 access files in **/home**, this could signal a compromise of the service if web
 content isn't published by users. If access should have been granted, then
 additional steps need to be taken to solve the problem.

2. The most common SELinux issue is an incorrect file context. This can occur
 when a file is created in a location with one file context and moved into a
 place where a different context is expected. In most cases, running ```restorecon```
 will correct the issue. Correcting issues in this way has a very narrow impact
 on the security of the rest of the system.

3. Another remedy for a too-restrictive access could be the adjustment of a
 SELinux boolean. For example, the **ftpd_anon_write** boolean controls whether
 anonymous FTP users can upload files. This boolean would have to be turned on
 if it is desirable to allow anonymous FTP users to upload files to a server.
 Adjusting booleans requires more care because they can have a broad impact on
 system security.

4. It is possible that the SELinux policy has a bug that prevents a legitimate
 access. If a bug has been identified, contact Red Hat support to report the bug
 so it can be resolved.

The **setroubleshoot-server** package must be installed to send SELinux messages
 to **/var/log/messages**. **setroubleshoot-server** listens for audit messages
 in **/var/log/audit/audit.log** and sends a short summary to **/var/log/messages**.
 This summary includes unique identifiers (UUIDs) for SELinux violations that can
 be used to gather further information. ```sealert -a /var/log/audit/ -l UUID```
 is used to produce a report for a specific incident. ```sealert -a /var/log/audit/audit.log```
 is used to produce reports for all incidents in that file.

```
# systemctl start nginx
# touch /root/test.html
# mv /root/test.html /use/share/nginx/html/test.html
# curl http://localhost/test.html
<html>
<head><title>403 Forbidden</title></head>
<body bgcolor="white">
<center><h1>403 Forbidden</h1></center>
<hr><center>nginx/1.14.1</center>
</body>
</html>
# tail /var/log/audit/audit.log
type=AVC msg=audit(1603393236.883:1279): avc:  denied  { read } for  pid=279289 comm="nginx" name="test.html" dev="sda3" ino=269128708 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:admin_home_t:s0 tclass=file permissive=0
# tail /var/log/messages
Oct 22 14:00:41 localhost setroubleshoot[280008]: SELinux is preventing nginx from read access on the file test.html. For complete SELinux messages run: sealert -l fe6f56fd-2efc-47c2-af84-631ec6e64eb7
Oct 22 14:00:41 localhost platform-python[280008]: SELinux is preventing nginx from read access on the file test.html.#012#012*****  Plugin catchall (100. confidence) suggests   **************************#012#012If you believe that nginx should be allowed read access on the test.html file by default.#012Then you should report this as a bug.#012You can generate a local policy module to allow this access.#012Do#012allow this access for now by executing:#012# ausearch -c 'nginx' --raw | audit2allow -M my-nginx#012# semodule -X 300 -i my-nginx.pp#012
```

Even though the contents of **test.html** are expected, the web server returns an
 error. Inspecting both **/var/log/audit.log** and **/var/log/messages** can
 reveal some extra information about this error.

Both log files indicate that an SELinux denial is the culprit. The ```sealert```
 command detailed in **/var/log/messages** can provide some extra information, 
 including a possible fix.

```
# sealert -l fe6f56fd-2efc-47c2-af84-631ec6e64eb7 
SELinux is preventing nginx from read access on the file test.html.

*****  Plugin catchall (100. confidence) suggests   **************************

If you believe that nginx should be allowed read access on the test.html file by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'nginx' --raw | audit2allow -M my-nginx
# semodule -X 300 -i my-nginx.pp


Additional Information:
Source Context                system_u:system_r:httpd_t:s0
Target Context                unconfined_u:object_r:admin_home_t:s0
Target Objects                test.html [ file ]
Source                        nginx
Source Path                   nginx
Port                          <Unknown>
Host                          DESKTOP-CDAHF4O.lan1
Source RPM Packages           
Target RPM Packages           
Policy RPM                    selinux-policy-3.14.3-41.el8_2.6.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Enforcing
Host Name                     DESKTOP-CDAHF4O.lan1
Platform                      Linux DESKTOP-CDAHF4O.lan1
                              4.18.0-193.19.1.el8_2.x86_64 #1 SMP Mon Sep 14
                              14:37:00 UTC 2020 x86_64 x86_64
Alert Count                   1
First Seen                    2020-10-25 14:25:51 CDT
Last Seen                     2020-10-25 14:25:51 CDT
Local ID                      fe6f56fd-2efc-47c2-af84-631ec6e64eb7

Raw Audit Messages
type=AVC msg=audit(1603653951.32:245): avc:  denied  { read } for  pid=38243 comm="nginx" name="test.html" dev="sdb3" ino=537187242 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:admin_home_t:s0 tclass=file permissive=0


Hash: nginx,httpd_t,admin_home_t,file,read
```
