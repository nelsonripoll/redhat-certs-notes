# Configure Simple File Sharing
Apache web server is the default HTTP server and vsFTP is the default corresponding
 FTP server. Configuration is simple and SELinux should be enabled.

1. Configure the noted services and enable them to start when the system is booted.
2. Mount and copy the contents of the CentOS 7 installation DVD or ISO to the
 appropriate directory.
3. Make sure the contents of the noted directories are configured with the right
 SELinux contexts.

## HTTP Service
Apache web server uses the /var/www/html directory by default and subdirectories
 can be created for file sharing. The main Apache configuration file is located
 at /etc/httpd/conf/httpd.conf. The default port number is 80 and needs to be
 opened in any existing firewall.

To install Apache web server, we must install the **httpd** package:

```
# yum -y install httpd
```

Use the following to start the httpd service and enable it to run when the system
 boots up:

```
# systemctl start httpd
# systemctl enable httpd
```

To open the ports for the HTTP service, the following commands:

```
# firewall-cmd --permanent --add-service http
# firewall-cmd --permanent --add-service https
# firewall-cmd --reload
```

To verify that everything is configured correctly, navigate your browser to 
 http://localhost or http://127.0.0.1 and you should see the default Apache
 web page.

## FTP Service
The Red Hat implementation of the vsFTP server uses the /var/ftp/pub directory
 for published files. The main FTP configuration file is located at 
 /etc/vsftpd/vsftpd.conf. The default ports for FTP is 20 and 21.

To install FTP server, we must install the **vsftpd** package:

```
# yum -y install vsftpd
```

Use the following to start the vsftpd service and enable it to run when the system
 boots up:

```
# systemctl start vsftpd
# systemctl enable vsftpd
```

To open the ports for the FTP service, run the following commands:

```
# firewall-cmd --permanent --add-service ftp
# firewall-cmd --reload
```

To verify that everything is configured correctly, navigate your browser to 
 ftp://localhost or ftp://127.0.0.1 and you should see the contents of the ftp
 directories.

## Mount and Copy
The **mount** command is used to connect a device (partition, USB, DVD drive, etc.)
 to a specified directory. For example, if the DVD is properly configured, it should
 automatically find the appropriate filesystem format from the /etc/filesystems
 file and can be mounted with the following command:

```
# mount /dev/cdrom /media
```

Alternatively, you can mount an ISO file to a directory:

```
# mount -o loop centos7.iso /media
```

Now you can copy the contents of the DVD or ISO to a directory configured on the
 file server of your choice (HTTP or FTP). The following copies all files in
 archive mode (-a) recursively:

```
# cp -a /media/. /path/to/dir
```

When you include the dot at the end of /media, you are including all hidden files
 in the copy command.

### HTTP
To copy the contents to the HTTP service, run the following commands:

```
# mkdir /var/www/html/inst
# cp -a /media/. /var/www/html/inst/
```

### FTP
To copy the contents to the HTTP service, run the following commands:

```
# mkdir /var/ftp/pub/inst
# cp -a /media/. /var/ftp/pub/inst/
```

## SELinux Context

To ensure the contents of the /var/www/html/inst directory has the correct
 SELinux context, run the following command:

```
# chcon -R --reference=/var/www/html /var/www/html/inst
```

The SELinux context for /var/www/html is httpd_sys_content_t and can be applied 
 directly:

```
# chcon -R -t httpd_sys_content_t /var/www/html/inst
```

To ensure the contents of the /var/ftp/pub/inst directory has the correct
 SELinux context, run the following command:

```
# chcon -R --reference=/var/ftp/pub /var/ftp/pub/inst
```

The SELinux context for /var/ftp/pub is public_content_t and can be applied 
 directly:

```
# chcon -R -t public_content_t /var/ftp/pub/inst
```

To view the context of a file or directly, you can use the **-Z** flag for the
 **ls** command:
 
```
# ls -Z /var/www/
drwxr-xr-x. root root system_u:object_r:httpd_sys_script_exec_t:s0 cgi-bin
drwxr-xr-x. root root system_u:object_r:httpd_sys_content_t:s0 html
```

The **-R** switch applies the context recursively and the **--reference=/path/to/dir**
 switch applies the default SELinux context for that directory.
