Mount ISO
```
# mount -o loop CentOS7.iso /media
```
Run the following commands then use a browser to navigate to ftp://localhost/pub/inst.
```
# yum install vsftpd
# mkdir /var/ftp/pub/inst
# mkdir /var/ftp/pub/ks
# cp -a /media/. /var/ftp/pub/inst
# cp /root/anaconda-ks.cfg /var/ftp/pub/ks/ks1.cfg
# chcon -R -t public_content_t /var/ftp/
# firewall-cmd --permanent --add-service=ftp
# firewall-cmd --reload
# systemctl restart vsftpd
```
