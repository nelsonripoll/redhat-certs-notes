Mount ISO
```
# mount -o loop CentOS7.iso /media
```
Run the following commands then use a browser to navigate to http://localhost/inst.
```
# yum install httpd
# mkdir /var/www/html/inst
# mkdir /var/www/html/ks
# cp -a /media/. /var/www/html/inst/
# cp /root/anaconda-ks.cfg /var/www/html/ks/ks1.cfg
# chcon -R --reference=/var/www/html /var/www/html/inst
# firewall-cmd --permanent --add-service=http
# firewall-cmd --reload
# systemctl restart httpd
```
