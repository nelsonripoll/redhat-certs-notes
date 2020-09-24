# Simple HTTP and FTP

## HTTP

There are two services available for a http daemon on RHEL 8: Apache and NGinx.

### Apache

#### Install and Configure Apache

The package required to install Apache is **httpd**.

```
# dnf info httpd
Name         : httpd
Version      : 2.4.37
Release      : 21.module_el8.2.0+494+1df74eae
Architecture : x86_64
Size         : 1.7 M
Source       : httpd-2.4.37-21.module_el8.2.0+494+1df74eae.src.rpm
Repository   : AppStream
Summary      : Apache HTTP Server
URL          : https://httpd.apache.org/
License      : ASL 2.0
Description  : The Apache HTTP Server is a powerful, efficient, and extensible
             : web server.
# dnf -y install httpd
# whereis httpd
httpd: /usr/lib64/httpd /etc/httpd
# systemctl start httpd
# systemctl enable httpd
```

The main configuration file is located at ```/etc/httpd/conf/httpd.conf```. The
 default document root directory is located at ```/var/www/html```.

### NGinx

The package required to install NGinx is **nginx**.

```
# dnf info nginx
Name         : nginx
Epoch        : 1
Version      : 1.14.1
Release      : 9.module_el8.0.0+184+e34fea82
Architecture : x86_64
Size         : 1.7 M
Source       : nginx-1.14.1-9.module_el8.0.0+184+e34fea82.src.rpm
Repository   : @System
From repo    : AppStream
Summary      : A high performance web server and reverse proxy server
URL          : http://nginx.org/
License      : BSD
Description  : Nginx is a web server and a reverse proxy server for HTTP, SMTP, POP3 and
             : IMAP protocols, with a strong focus on high concurrency, performance and low
             : memory usage.
# dnf -y install nginx
# whereis nginx
nginx: /usr/sbin/nginx /usr/lib64/nginx /etc/nginx /usr/share/nginx /usr/share/man/man3/nginx.3pm.gz /usr/share/man/man8/nginx.8.gz
# systemctl start nginx
# systemctl enable nginx
```

The main configuration file is located at ```/etc/nginx/nginx.conf```. The defaut
 document root is located at ```/usr/share/nginx/html```.

### HTTP(S) Firewall

```
# firewall-cmd --zone=public --permanent --add-service=http
# firewall-cmd --zone=public --permanent --add-service=https
# firewall-cmd --reload
```

## FTP

There is one service available for a ftp daemon on RHEL 8: Very Secure FTP

### Very Secure FTP

The package required to install Very Secure FTP is **vsftpd**.

```
# dnf info vsftpd
Name         : vsftpd
Version      : 3.0.3
Release      : 31.el8
Architecture : x86_64
Size         : 343 k
Source       : vsftpd-3.0.3-31.el8.src.rpm
Repository   : @System
From repo    : AppStream
Summary      : Very Secure Ftp Daemon
URL          : https://security.appspot.com/vsftpd.html
License      : GPLv2 with exceptions
Description  : vsftpd is a Very Secure FTP daemon. It was written completely from
             : scratch.
# dnf -y install vsftpd
# whereis vsftpd
vsftpd: /usr/sbin/vsftpd /etc/vsftpd /usr/share/man/man8/vsftpd.8.gz
# systemctl start vsftpd
# systemctl enable vsftpd
```

The main configuration file is located at ```/etc/vsftpd/vsftpd.conf```. The
 default document root directory is located at ```/var/ftp/pub```.

### FTP Firewall

```
# firewall-cmd --zone=public --permanent --add-service=ftp
# firewall-cmd --zone=public --permanent --add-service=sftp
# firewall-cmd --reload
```
