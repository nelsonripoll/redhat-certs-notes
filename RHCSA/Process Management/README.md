# Process Management

## Process Control Using Signals

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

### Killing Processes Exercise

Open two terminals. In the left window, start three processes that append to a
 text file. In the right window, use ```tail``` to confirm that all three
 processes are appending to the file. In the left window, view ```jobs``` to
 see all three processes "Running".

** LEFT **
```
# (while true; do echo -n "game " >> ~/outfile; sleep 1; done) &
[1] 109844
# (while true; do echo -n "set " >> ~/outfile; sleep 1; done) &
[2] 109920
# (while true; do echo -n "match " >> ~/outfile; sleep 1; done) &
[3] 109982
# jobs
[1]    running    ( while true; do; echo -n "game " >> ~/outfile; sleep 1; done; )
[2]    running    ( while true; do; echo -n "set " >> ~/outfile; sleep 1; done; )
[3]  - running    ( while true; do; echo -n "match " >> ~/outfile; sleep 1; done; )
```

** RIGHT **
```
# tail -f ~/outfile
```

Suspend the "game" process using signals. Confirm that the "game" process is 
 "Stopped". In the right window, confirm "game" is no longer being written.

```
# kill -SIGSTOP %1
[1]  + suspended (signal)  ( while true; do; echo -n "game " >> ~/outfile; sleep 1; done; )
[2]    running    ( while true; do; echo -n "set " >> ~/outfile; sleep 1; done; )
[3]    running    ( while true; do; echo -n "match " >> ~/outfile; sleep 1; done; )
```

Terminate the "set" process using signals. Confirm that the "set" process has
 disappeared. In the right window, confirm "set" is no longer being written.

```
# kill -SIGTERM %2
# jobs
[1]  + suspended (signal)  ( while true; do; echo -n "game " >> ~/outfile; sleep 1; done; )
[3]    running    ( while true; do; echo -n "match " >> ~/outfile; sleep 1; done; )
```

Resume the "game" process using signals. Confirm that the "game" process is
 "Running". In the right window, confirm "game" is being written again.

```
# kill -SIGCONT %1
# jobs
[1]    running    ( while true; do; echo -n "game " >> ~/outfile; sleep 1; done; )
[3]  - running    ( while true; do; echo -n "match " >> ~/outfile; sleep 1; done; )
```

Terminate the remaining two jobs. Confirm that no jobs remain and that output has
 stopped. From the left window, terminate the right window's ```tail``` command.

```
# kill -SIGTERM %1
# kill -SIGTERM %3
# jobs
# pkill -SIGTERM tail
```
