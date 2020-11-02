# Process Management

## Killing Processes

A signal is a software interrupt delivered to a process. Signals report events
 to an executing program. Events that generate a signal can be an _error_,
 _external event_ (e.g., I/O request or expired timer), or by _explicit request_,
 (e.g., use of a signal-sending command or by keyboard sequence).

The following table lists the fundamentals signals used by system administrators
 for routine process management. Refer to signals by either their short (**HUP**)
 or proper (**SIGHUP**) name.

Signal Number | Short Name | Definition         | Purpose
------------- | ---------- | ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------
1             | HUP        | Hangup             | Used to report termination of the controlling process of a terminal. Also used to request process reinitialization without termination.
2             | INT        | Keyboard interrupt | Causes program termination. Can be blocked or handled. Sent by pressing **INTR** key combination (**Ctrl+c**).
3             | QUIT       | Keyboard quit      | Similar to **SIGINT**, but also produces a process dump at termination. Sent by pressing **QUIT** key combination (**Ctrl+\**).
9             | KILL       | Kill, unblockable  | Causes abrupt program termination. Cannot be blocked, ignored, or handled; always fatal.
15 (default)  | TERM       | Terminate          | Causes program termination. Unlike **SIGKILL**, can be blocked, ignored, or handled. The polite way to ask a program to terminate; allows self-cleanup.
18            | CONT       | Continue           | Sent to a process to resume if stopped. Cannot be blocked. Even if handled, always resumes the process.
19            | STOP       | Stop, unblockable  | Suspends the process. Cannot be blocked or handled.
20            | TSTP       | Keyboard stop      | Unlike **SIGSTOP**, can be blocked, ignore, or handled. Sent by pressing **SUSP** key combination (**Ctrl+z**).

Each signal has a _default action_, usually one of the following:

* _Term_ - Cause a program to terminate (exit) at once.
* _Core_ - Cause a program to save a memory image (core dump), then terminate.
* _Stop_ - Cause a program to stop executing (suspend) and wait to continue (resume).

Users signal their current foreground process by pressing a keyboard control
 sequence to suspend (**Ctrl+z**), kill (**Ctrl+c**), or core dump (**Ctrl+\**)
 the process. To signal a background process or processes in a different session
 requires a signal-sending command.

Signals can by specified either by their name (e.g., **-HUP** or **-SIGHUP**) or
 by number (e.g., **-1**).

The ```kill``` command sends a signal to a process by ID.

```
# kill PID
# kill -signal PID
# kill -l
HUP INT QUIT ILL TRAP ABRT BUS FPE KILL USR1 SEGV USR2 PIPE ALRM TERM STKFLT CHLD CONT STOP TSTP TTIN TTOU URG XCPU XFSZ VTALRM PROF WINCH POLL PWR SYS
```

The ```killall``` command sends a signal to one or more processes matching a
 selection criteria.

```
# killall command_pattern
# killall -signal command_pattern
# killall -signal -u username command_pattern
```

The ```pkill``` command, like ```killall```, can signal multiple processes.
 ```pkill``` uses advanced selection criteria, which can include combinations
 of:

* _Command_ - Processes with a pattern-matched command name.
* _UID_ - Processes owned by a Linux user account, effective or real.
* _GID_ - Processes owned by a Linux group account, effective or real.
* _Parent_ - Child processes of a specific parent process.
* _Terminal_ - Processes running on a specific controlling terminal.

```
# pkill command_pattern
# pkill -signal command_pattern
# pkill -G GID command_pattern
# pkill -P PPID command_pattern
# pkill -t terminal_name -U UID command_pattern
```

The ```w``` command views users currently logged into the system and their
 cumulative activities. All users have a controlling terminal, listed as 
 **pts/N** while working in a graphical environment window (_pseudo-terminal)
 or **ttyN** on a system console, alternate console, or other directly connected
 terminal device.

User processes and sessions can be individually or collectively signaled.
 Because the initial process in a login session (_session leader_) is designed
 to handle session termination requests and ignore unintended keyboard signals,
 killing all of a user's processes and login shells requires using the **SIGKILL**
 signal. The session leader successfully handles and survives the termination
 request, but all other session processes are terminated:

```
# pgrep -l -u bob
6964 bash
6998 sleep
6999 sleep
7000 sleep
# w -u bob
11:18:34 up 7 days,  4:40,  1 user,  load average: 0.11, 0.05, 0.01
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU  WHAT
bob      tty3     tty3             26Oct20  7days  1:54m  3.11s -bash
# pkill -t tty3
# pgrep -l -u bob
6964 bash
# pkill -SIGKILL -t tty3
# pgrep -l -u bob
```

The ```pstree``` command views a process tree for the system or a single user.
 Use a parent process's PID to kill all children they have created. This time,
 the parent **bash** login shell survives because the signal is directed only
 at its child processes:

```
# pstree -p bob
bash(2176)─┬─sleep(2177)
           ├─sleep(2178)
           └─sleep(2278)
# pkill -P 2176
# pgrep -l -u bob
bash(2176)
# pkill -SIGKILL -P 2176
# pgrep -l -u bob
bash(2176)
```
## Monitoring Process Activity

The Linux kernel calculates a _load average_ metric as an _exponential moving
 average_ of the _load number_, a cumulative CPU count of active system resource
 requests.

* _Active requests_ are counted from per-CPU queues for running threads and
 threads waiting for I/O, as the kernel tracks process activity and corresponding
 process state changes.
* _Load number_ is a calculation routine run every five seconds by default, which
 accumulates and averages the active requests into a single number for all CPUs.
* _Exponential moving average_ is a mathematical formula to smooth out trending
 data highs and lows, increase current activity significance, and decrease
 aging data quality.
* _Load average_ is the load number calculation routine result. Collectively, it
 refers to the three displayed values of system activity data averaged for the
 last 1, 5, and 15 minutes.

```top```, ```uptime```, ```w```, and ```gnome-system-monitor``` display load
 average values:

```
# top
top - 13:23:30 up 7 days,  6:45,  1 user,  load average: 2.92, 4.48, 5.20
Tasks: 251 total,   1 running, 249 sleeping,   1 stopped,   0 zombie
%Cpu(s):  1.5 us,  0.4 sy,  0.0 ni, 98.0 id,  0.0 wa,  0.1 hi,  0.0 si,  0.0 st
MiB Mem :   7727.5 total,   3699.9 free,   1987.7 used,   2039.9 buff/cache
MiB Swap:   7946.0 total,   7946.0 free,      0.0 used.   5016.1 avail Mem
```

```
# uptime
15:29:03 up 14 min, 1 user, load average: 2.92, 4.48, 5.20
```

```
# w -u bob
11:18:34 up 7 days,  4:40,  1 user,  load average: 2.92, 4.48, 5.20
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU  WHAT
bob      tty3     tty3             26Oct20  7days  1:54m  3.11s -bash
```

Divide the displayed load average values by the number of logical CPUs in the
 system. A value below 1 indicates satisfactory resource utilization and minimal
 wait times. A value above 1 indicates resource saturation and some amount of
 service waiting times.

To see how manu logical CPUs your system has, check the **/proc/cpuinfo** file:

```
model name	: Intel(R) Core(TM) i5-4590T CPU @ 2.00GHz
model name	: Intel(R) Core(TM) i5-4590T CPU @ 2.00GHz
model name	: Intel(R) Core(TM) i5-4590T CPU @ 2.00GHz
model name	: Intel(R) Core(TM) i5-4590T CPU @ 2.00GHz
```

With a load average of 2.92 in the last 1 minute on four CPUs, all CPUs were in 
 use ~73% of the time (2.92 / 4 = 0.73). During the last 5 minutes, the system 
 was overloaded by ~12% (4.48 / 4 = 1.12). During the last 15 minutes, the 
 system was overloaded by ~30% (5.20 / 4 = 1.30). The system's load average
 appears to be decreasing.

The ```top``` program is a dynamic view of the system's processes, displaying
 a summary header followed by a process or thread list similar to ```ps```
 information. Unlike the static ```ps``` output, ```top``` continuously refreshes
 at a configurable interval, and provides capabilities for column reordering,
 sorting, and highlighting.

**Default columns**
* The process ID (**PID**).
* User name (**USER**) is the process owner.
* Virtual memory (**VIRT**) is all memory the process is using, including the
 resident set, shared libraries, and any mapped or swapped memory pages. (labeled
 **VSZ** in the ```ps``` command)
* Resident memory (**RES**) is the physical memory used by the process, including
 any resident shared objects. (labeled **RSS** in the ```ps``` command)
* Process state (**S**) displays as:
  * Uninterruptable Sleeping (**D**)
  * Running or Runnable (**R**)
  * Sleeping (**S**)
  * Stopped or Traced (**T**)
  * Zombie (**Z**)
* CPU time (**TIME**) is the total processing time since the process started.
 May be toggled to include cumulative time of all previous children.
* The process command name (**COMMAND**).

**Fundamental keystrokes in top**
Key     | Purpose
------- | -------------------------------------------------------------------------------------
? or h  | Help for interactive keystrokes.
l, t, m | Toggles for load, threads, and memory header lines
1       | Toggle showing individual CPUs or a summary for all CPUs in header.
s       | Change the refresh (screen) rate, in decimal seconds (e.g., 0.5, 1, 5).
b       | Toggle reverse highlighting for _Running_ processes; default is bold only.
B       | Enables use of bold in display, in the header, and for _Running_ processes.
H       | Toggle threads; show process summary or individual threads.
u, U    | Filter for any user name (effective, real).
M       | Sorts process listing by memory usage, in descending order.
P       | Sorts process listing by process utilization, in descending order.
k       | Kill a process. When prompted, enter **PID**, then **signal**.
r       | Renice a process. When prompted, enter **PID**, then **signal**.
W       | Write (save) the current display configuration for use at the next ```top``` restart.
q       | Quit.

The keystrokes **s**, **k**, and **r** are not available if ```top``` is started
 in secure mode.

## Using Nice and Renice to Influence Process Priority

The ```top``` command can be used to interactively view (and manage) processes.
 In a default configuration, ```top``` will display two columns of interest to
 the nice level: **NI** with the actual nice level, and **PR**, which displays
 the nice level as mapped to a larger priority queue, with a nice level of **-20**
 mapping to a piority of **0** and a nice level of **+19** mapping to a priority
 of **39**. The ```ps``` command can also display nice levels for processes, 
 although it does not do so in most of its default output formats.

```
# ps axo pid,comm,nice --sort=-nice
```

Whenever a process is started, it will normally inherit the nice level from its
 parent. To start a process with a different nice level, run the process with
 the ```nice``` command. Without any other options, running ```nice COMMAND```
 will start the command with a nice level of 10. Use the **-n** flag to specify
 the nice level.

```
# nice -n 15 restorecon -R /var/www/*
```

An existing process can have its nice level changed with the ```renice``` command.

```
renice -n 19 PID
```

The ```top``` command can also be used to (interactively) change the nice level
 on a process. From within ```top```, press **r**, followed by the PID to be
 changed and the new nice level.

Unprivileged users are only allowed to set a positive nice level (0 to 19) or
 raise the nice level on their existing processes. Only root can set a negative 
 nice level (-20 to -1) or lower nice levels on existing processes.
