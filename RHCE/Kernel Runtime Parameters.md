# Kernel Runtime Parameters

## Display All Values

There are two ways to display all kernel parameter values. You can either use
 the `sysctl -a` command or view the contents of the directories located in
 **/proc/sys/**.

```
# ll /proc/sys/
# ll /proc/sys/kernel

# sysctl -a
```

To view the value of a specific parameter, use `sysctl` or view the file content.

```
# sysctl kernel.version
# cat /proc/sys/kernel/version
```

To change the value of a kernel parameter, use `sysctl`.

```
# sysctl kernel.sysrq
16
# sysctl -w kernel.sysrq=32
kernel.sysrq = 32
# sysctl kernel.sysrq
kernel.sysrq = 32
# cat /proc/sys/kernel/sysrq
32
```

You can also change the value of a kernel parameter if the file is writable.

```
# ll /proc/sys/kernel/sysrq
-rw-r--r--. 1 root root 0 Nov 24 22:46 /proc/sys/kernel/sysrq
# cat /proc/sys/kernel/sysrq
16
# echo "48" > /proc/sys/kernel/sysrq 
# sysctl kernel.sysrq
kernel.sysrq = 48
# cat /proc/sys/kernel/sysrq
48
```

To make the changes permanent, update the **/etc/sysctl.conf** or add a new conf
 to **/usr/lib/sysctl.d/** directory.

```
# sysctl kernel.threads-max
kernel.threads-max = 7548
# echo "kernel.threads-max = 7550" >> /etc/sysctl.conf
# reboot
# sysctl kernel.threads-max
kernel.threads-max = 7550
```
