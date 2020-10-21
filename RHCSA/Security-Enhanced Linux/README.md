# Security-Enhanced Linux

Security-Enhanced Linux (SELinux) was developed by the U.S. National Security 
 Agency to provide a level of mandatory access control for Linux. It enforces 
 security rules within the kernel of the operating system.

SELinux is a set of security rules that determine which process can access which 
 files, directories, and ports. Every file, process, directory, and port has a 
 special security label called a SELinux context. A context is a name that is 
 used by the SELinux policy to determine whether a process can access a file, 
 directory, or port.

SELinux labels have several contexts: user, role, type, and sensitivity. The
 targeted policy, which is the default policy enabled in RHEL, bases its rules
 on the type context. Type context names usually end with **\_t**. The type 
 context for the web server is **httpd\_t**. The type context for files and
 directories normally found in **/var/www/html** is **httpd\_sys\_content\_t**.
 The type contexts for files and directories normally found in **/tmp** and
 **/var/tmp** is **tmp\_t**. The type context for web server ports is 
 **http\_port\_t**.
