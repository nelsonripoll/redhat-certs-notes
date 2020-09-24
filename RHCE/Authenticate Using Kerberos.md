# Authenticate Using Kerberos

## Server Setup

### Install Packages
```
# yum install -y krb5-server krb5-workstation pam_krb5
```

### Configure

Kerberos depends on fully qualified domain names. Whatever changes you make, make
 sure you maintain the case. For example, if you are changing **EXAMPLE.COM**,
 whatever you change it too must also be in all caps.

#### /var/kerberos/krb5kdc/kdc.conf
Replace the domain 'EXAMPLE.COM' with the domain of your environment. Additionally,
 if you wish to remove backwards compatibility from Kerberos, uncomment the lines
 `#master_key_type = aes256-cts` and `#default_principal_flags = +preauth`.

```
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88

[realms]
 EXAMPLE.COM = {
  #master_key_type = aes256-cts
  #default_principal_flags = +preauth
  acl_file = /var/kerberos/krb5kdc/kadm5.acl
  dict_file = /usr/share/dict/words
  admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
  supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal camellia256-cts:normal camellia128-cts:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal
 }
```

#### /var/kerberos/krb5kdc/kadm5.acl
Replace the domain 'EXAMPLE.COM' with the domain of your environment.
```
*/admin@EXAMPLE.COM     *
```

#### /etc/krb5.conf
Uncomment all commented lines.Replace the domain 'EXAMPLE.COM' with the domain 
 of your environment. Under the `[realms]` section, replace `kerberos.example.com`
 with the hostname of your kerberos server.
```
# Configuration snippets may be placed in this directory as well
includedir /etc/krb5.conf.d/

[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 pkinit_anchors = /etc/pki/tls/certs/ca-bundle.crt
# default_realm = EXAMPLE.COM
 default_ccache_name = KEYRING:persistent:%{uid}

[realms]
# EXAMPLE.COM = {
#  kdc = kerberos.example.com
#  admin_server = kerberos.example.com
# }

[domain_realm]
# .example.com = EXAMPLE.COM
# example.com = EXAMPLE.COM
```

### Create Kerberos Database

Use `kdb5_util` to create the kerberos database with the realm we will be working
 with. This could take a few minutes as it creates data and uses `/dev/random` to
 generate entropy and create secure keys.

```
# kdb5_util create -s -r EXAMPLE.COM
Loading random data
Initializing database '/var/kerberos/krb5kdc/principal' for realm 'EXAMPLE.COM',
master key name 'K/M@EXAMPLE.COM'
You will be prompted for the database Master Password.
It is important that you NOT FORGET this password.
Enter KDC database master key:
Re-enter KDC database master key to verify:
```

Start and enable the kerberos service.
```
# systemctl enable krb5kdc kadmin
Created symlink from /etc/systemd/system/multi-user.target.wants/krb5kdc.service to /usr/lib/systemd/system/krb5kdc.service.
Created symlink from /etc/systemd/system/multi-user.target.wants/kadmin.service to /usr/lib/systemd/system/kadmin.service.
# systemctl start krb5kdc kadmin
```

Now we use the kerberos admin tool to add principals. We are going to create a
 root/admin account for the actual system. The `kadmin` tool will start a new
 prompt, the `.local` part tells us it is for this local system. If this was a
 client system, we would omit the `.local` so we can connect to our remote
 kerberos server.
```
# kadmin.local
Authenticating as principal root/admin@EXAMPLE.COM with password.
kadmin.local:
```

Now that we have our `kadmin` prompt, we can start configuring the system. Start
 by adding a principal for the root/admin account.
```
kadmin.local:  addprinc root/admin
WARNING: no policy specified for root/admin@EXAMPLE.COM; defaulting to no policy
Enter password for principal "root/admin@EXAMPLE.COM":
Re-enter password for principal "root/admin@EXAMPLE.COM":
Principal "root/admin@EXAMPLE.COM" created.
```

Next, we will create a principal for a user account we can use to authenticate
 against kerberos. The user will be called `krbuser`.
```
kadmin.local:  addprinc krbuser
WARNING: no policy specified for krbuser@EXAMPLE.COM; defaulting to no policy
Enter password for principal "krbuser@EXAMPLE.COM":
Re-enter password for principal "krbuser@EXAMPLE.COM":
Principal "krbuser@EXAMPLE.COM" created.
```

The hostname of the kdc server needs to be added to the kerberos database.
```
kadmin.local: addprinc -randkey host/kdc-server.example.com
WARNING: no policy specified for host/kdc-server.mylabserver.com@EXAMPLE.COM; defaulting to no policy
Principal "host/kdc-server.mylabserver.com@EXAMPLE.COM" created.
```

All of this needs to be stored to a local keytab file in the `/etc/` directory.
```
kadmin.local:  ktadd host/kdc-server.example.com
Entry for principal host/kdc-server.example.com with kvno 2, encryption type aes256-cts-hmac-sha1-96 added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/kdc-server.example.com with kvno 2, encryption type aes128-cts-hmac-sha1-96 added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/kdc-server.example.com with kvno 2, encryption type des3-cbc-sha1 added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/kdc-server.example.com with kvno 2, encryption type arcfour-hmac added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/kdc-server.example.com with kvno 2, encryption type camellia256-cts-cmac added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/kdc-server.example.com with kvno 2, encryption type camellia128-cts-cmac added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/kdc-server.example.com with kvno 2, encryption type des-hmac-sha1 added to keytab FILE:/etc/krb5.keytab.
Entry for principal host/kdc-server.example.com with kvno 2, encryption type des-cbc-md5 added to keytab FILE:/etc/krb5.keytab.
```

Finally, quit the kadmin prompt.
```
kadmin.local: quit
```

Verify the keytab file was created.
```
# ls /etc/*keytab
krb5.keytab
```

### Test Authentication
First we need to modify the ssh configuration.

#### /etc/ssh/ssh_config
Look for `# GSSAPIAuthentication no` and `# GSSAPIDelegateCredentials no`, uncomment
 these two lines and change the value to yes.
```
...
GSSAPIAuthentication yes
GSSAPIDelegateCredentials yes
...
```

Reload ssh.
```
# systemctl reload sshd
```

Update the kerberos authentication configuration.
```
# authconfig --enablekrb5 --update
```

You may need to open up some ports if you are on an environment where a firewall
 is installed and running. Open ports TCP 88 and 749 along with UDP 88. Create
 a custom firewalld service.

#### /etc/firewalld/services/kerberos.xml
```
<?xml version=”1.0” encoding=”utf-8”?>
<service>
  <short>Kerberos</short>
  <description>Kerberos network authentication protocol server</description>
  <port protocol=”tcp” port=”88”/> 
  <port protocol=”tcp” port=”749”/>
  <port protocol=”udp” port=”88”/> 
</service>
```

Apply the firewall changes.
```
# firewall-cmd --permenant --add-service=kerberos
# firewall-cmd --reload
```

Create the krbuser user and switch to that user. Run kinit to initialize kerberos,
 then run klist to see if the test ran successfully. Finally, ssh into the kerberos
 server.
```
# useradd krbuser
# su - krbuser
$ kinit
Password for krbtest@EXAMPLE.COM:
$ klist
Ticket cache: KEYRING:persistent:1004:1004
Default principal: krbuser@EXAMPLE.COM

Valid starting       Expires              Service principal
11/27/2019 10:07:18  11/28/2019 10:07:18  krbtgt/EXAMPLE.COM@EXAMPLE.COM
$ ssh kdc-server.example.com
The authenticity of host 'kdc-server.example.com (fe80::107a:faff:fee6:6ecb%eth0)' can't be established.
ECDSA key fingerprint is SHA256:eE+bkc51Q1L1Tr06jzcFLzhQB9wv1Ai2PqnhoZstU84.
ECDSA key fingerprint is MD5:43:41:71:79:a3:66:9e:d4:ee:4b:e7:9d:a8:23:1f:79.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'kdc-server.example.com,fe80::107a:faff:fee6:6ecb%eth0' (ECDSA) to the list of known hosts.
[krbuser@kdc-server ~]$
```

## Client Setup

### Install Packages
```
# yum install -y krb5-workstation pam_krb5
```

### Configure
#### /etc/krb5.conf
Uncomment all commented lines.Replace the domain 'EXAMPLE.COM' with the domain 
 of your environment. Under the `[realms]` section, replace `kerberos.example.com`
 with the hostname of your kerberos server.
```
# Configuration snippets may be placed in this directory as well
includedir /etc/krb5.conf.d/

[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 pkinit_anchors = /etc/pki/tls/certs/ca-bundle.crt
# default_realm = EXAMPLE.COM
 default_ccache_name = KEYRING:persistent:%{uid}

[realms]
# EXAMPLE.COM = {
#  kdc = kerberos.example.com
#  admin_server = kerberos.example.com
# }

[domain_realm]
# .example.com = EXAMPLE.COM
# example.com = EXAMPLE.COM
```

```
# useradd krbuser
```

```
# kadmin
```

```
kadmin: addprinc -randkey host/kerb-client.example.com
kadmin: ktadd host/kerb-client.mylabserver.com
```

#### /etc/ssh/ssh_config
Look for `# GSSAPIAuthentication no` and `# GSSAPIDelegateCredentials no`, uncomment
 these two lines and change the value to yes.
```
...
GSSAPIAuthentication yes
GSSAPIDelegateCredentials yes
...
```

Reload ssh.
```
# systemctl reload sshd
```

Update the kerberos authentication configuration.
```
# authconfig --enablekrb5 --update
# su - krbuser
$ ssh kdc-server.example.com
```
