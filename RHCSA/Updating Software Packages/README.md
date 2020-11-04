# Updating Software Packages

## Red Hat Subscription Management

Red Hat Subscription Management provides tools that can be used to entitle
 machines to product subscriptions, allowing administrators to get updates to
 software packages and track information about support contracts and subscriptions
 used by the systems.

There are four basic tasks performed with Red Hat Subscription Management tools:
* **Register** a system to associate that system to a Red Hat account.
* **Subscribe** a system to entitle it to updates for selected Red Hat products.
* **Enable repositories** to provide software packages.
* **Review and track** entitlements which are available or consumed.

The ```subscription-manager``` command is used to register a system without
 using the graphical environment.

**Register a system to a Red Hat account:**
```
# subscription-manager register --username=yourusername --password=yourpassword
```

**View available subscriptions:**
```
# subscription-manager list --available
```

**Auto-attach a subscription:**
```
# subscription-manager attach --auto
```

**View consumed subscriptions:**
```
# subscription-manager list --consumed
```

**Unregister a system:**
```
# subscription-manager unregister
```

An entitlement is a subscription that's been attached to a system. Digital
 certificates are used to store current information about entitlements on the
 local system. Once registered, the entitlement certificates are stored in
 **/etc/pki** and its subdirectories.

* **/etc/pki/product** contains certificates which indicate Red Hat products
 installed on the system.
* **/etc/pki/consumer** contains certificates which indicate the Red Hat account
 to which the system is registered.
* **/etc/pki/entitlement** contains certificates which indicate which subscriptions
 are attached to the system.

The certificates can be inspected with the ```rct``` utility directly, but
 normally the ```subscription-manager``` tools are a more user-friendly way to
 examine the subscriptions that are attached to the system.

## Managing Software With dnf

```dnf``` is a powerful command-line tool that can be used to more flexibly
 manage (install, update, remove, and query) software packages. Official Red
 Hat packages are normally downloaded from Red Hat's content distribution
 network.

* **dnf help** will display usage information.
* **dnf list** displays installed and available packages.
* **dnf search KEYWORD** lists packages by keywords found in the name and summary
 fields only. To search name, summary, and description use **dnf search all KEYWORD**.
* **dnf info PACKAGENAME** gives detailed information about a package, including
 disk space needed for installation.
* **dnf provides PATHNAME** displays packages that match the pathname specified.
* **dnf install PACKAGENAME** obtains and installs a software package, including
 any dependencies.
* **dnf update PACKAGENAME** obtains and installs a newer version of the software
 package, including any dependencies. To update all packages, do not list a
 package name. Kernel packages are always installed, never updated, in case a
 newer kernel package fails to boot the older ones remain available.
* **dnf remove PACKAGENAME** removes an installed software package, including any
 supported packages.
* **dnf repolist** lists all enabled repositories. To list all available
 repositories, use **dnf repolist all**.
* **dnf config-manager** manage dnf configuration options and repositories.


```dnf``` can also handle group packages. The commands are similar, just add the
 word **group** after **dnf** but before the command. For example, 
 ```dnf group list``` or ```dnf group install GROUPNAME```.

## Enabling dnf Software Repositories

**To enable repositories:**
```
# dnf repolist all
repo id                        repo name                                status
AppStream                      CentOS-8 - AppStream                     enabled
AppStream-source               CentOS-8 - AppStream Sources             disabled
BaseOS                         CentOS-8 - Base                          enabled
BaseOS-source                  CentOS-8 - BaseOS Sources                disabled
Devel                          CentOS-8 - Devel WARNING! FOR BUILDROOT  disabled
HighAvailability               CentOS-8 - HA                            disabled
PowerTools                     CentOS-8 - PowerTools                    disabled
base-debuginfo                 CentOS-8 - Debuginfo                     disabled
c8-media-AppStream             CentOS-AppStream-8 - Media               disabled
c8-media-BaseOS                CentOS-BaseOS-8 - Media                  disabled
centosplus                     CentOS-8 - Plus                          disabled
centosplus-source              CentOS-8 - Plus Sources                  disabled
cr                             CentOS-8 - cr                            disabled
epel                           Extra Packages for Enterprise Linux 8 -  enabled
epel-debuginfo                 Extra Packages for Enterprise Linux 8 -  disabled
epel-modular                   Extra Packages for Enterprise Linux Modu enabled
epel-modular-debuginfo         Extra Packages for Enterprise Linux Modu disabled
epel-modular-source            Extra Packages for Enterprise Linux Modu disabled
epel-playground                Extra Packages for Enterprise Linux 8 -  disabled
epel-playground-debuginfo      Extra Packages for Enterprise Linux 8 -  disabled
epel-playground-source         Extra Packages for Enterprise Linux 8 -  disabled
epel-source                    Extra Packages for Enterprise Linux 8 -  disabled
epel-testing                   Extra Packages for Enterprise Linux 8 -  disabled
epel-testing-debuginfo         Extra Packages for Enterprise Linux 8 -  disabled
epel-testing-modular           Extra Packages for Enterprise Linux Modu disabled
epel-testing-modular-debuginfo Extra Packages for Enterprise Linux Modu disabled
epel-testing-modular-source    Extra Packages for Enterprise Linux Modu disabled
epel-testing-source            Extra Packages for Enterprise Linux 8 -  disabled
extras                         CentOS-8 - Extras                        enabled
extras-source                  CentOS-8 - Extras Sources                disabled
fasttrack                      CentOS-8 - fasttrack                     disabled
# dnf config-manager --enable centosplus
# dnf repolist
repo id            repo name
AppStream          CentOS-8 - AppStream
BaseOS             CentOS-8 - Base
centosplus         CentOS-8 - Plus
epel               Extra Packages for Enterprise Linux 8 - x86_64
epel-modular       Extra Packages for Enterprise Linux Modular 8 - x86_64
extras             CentOS-8 - Extras
# dnf config-manager --disable centosplus
# dnf repolist
repo id            repo name
AppStream          CentOS-8 - AppStream
BaseOS             CentOS-8 - Base
epel               Extra Packages for Enterprise Linux 8 - x86_64
epel-modular       Extra Packages for Enterprise Linux Modular 8 - x86_64
extras             CentOS-8 - Extras
```

**To enable third-party repositories:**
```
# dnf config-manager --add-repo=URL
```

Some repositories provide this configuration file and GPG public key as part of
 an RPM package.

```
# rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
# dnf install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
```
