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
