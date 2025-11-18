# RootScope  

**RootScope** is a Linux black box recorder — a source of truth for everything that changes on your system.  
Like `git blame`, but for processes, files, and mounts — it traces every event back to the process and user that caused it, even if the process is already gone.

It runs entirely in userspace, using kernel primitives like **audit netlink**, **fanotify**, and **udev** to capture file, process, and device activity in real time. These raw signals are automatically correlated into a searchable timeline that reconstructs what actually happened — not just what was logged.


## ⚙️ Installation

RootScope is fully tested on the following distributions:
- **Ubuntu** 22.04 LTS / 24.04 / 25.04  
- **Debian** 11 (Bullseye) / 12 (Bookworm)  
- Other **systemd-based** distributions may work, but are not officially supported yet.

> ⚠️ Root privileges required <br>
> RootScope installs as a `systemd` service and monitors low-level system events, so it must be installed and run as root. <br>
> For details on what subsystems and permissions are used under the hood, see the [**How it works**](#how-it-works) section below. <br>
> No external network access is made during installation — all components run locally. <br>

Install RootScope in one step using `curl`:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/RootScopeInc/RootScope/refs/heads/main/install_rootscope.sh)
```

Once done, verify the CLI is available:

```bash
rsctl -h
```

You should now see the command list and usage examples.

## 🖥️ Example Output

The trace below shows RootScope capturing real system behavior — surfacing file, process, and mount activity that normally happens silently in the background.

```bash
ubuntu@ip-172-26-9-81:~$ rsctl query --since 5m
Query parameters summary:
  Time range         : set → unset
  Display order      : latest to oldest

2025-10-07 00:35:11  [#6059] [File System]
↳ create on /tmp/systemd-private-92465aa8743f4309b7b717ab5306f88b-apt-news.service-FTJT1Q
  by root (pid=1) via /usr/lib/systemd/systemd

2025-10-07 00:35:10  [#6058] [File System]
↳ attrib on /var/lib/apt/lists/auxfiles
  by root (pid=179789) via /usr/bin/apt

2025-10-07 00:35:10  [#6056] [File System]
↳ modify, close-write on /tmp/#3698
  by root (pid=179789) via /usr/bin/apt

2025-10-07 00:34:51  [#6054] [File System]
↳ modify, close-write, delete on /var/tmp/etilqs_3f98709c8586f41c
  by ubuntu (pid=179744) via /usr/bin/rootscope/rsctl

2025-10-07 00:34:51  [#6053] [File System]
↳ create on /var/tmp/etilqs_3f98709c8586f41c
  by ubuntu (pid=179744) via /usr/bin/rootscope/rsctl

2025-10-07 00:31:57  [#6050] [Mount]
↳ remount EXT2/3/4 → /var/log/rootscope/rootscope_user_data
  by root (pid=179348) via /usr/bin/mount
```

Each event shows a precise timestamp, operation type, and the process responsible — even if that process has already exited.

## 🧪 Try RootScope Without Installing

If you’re not on one of the supported distros, you can try RootScope in a Playground VM — a zero-setup environment that lets you explore it right away.

It simulates real system activity and shows how RootScope captures events that typical logging tools overlook.

No installation, no setup — just SSH in and start experimenting.

### 🔐 How to Access the Playground

1. Send your **public SSH key** to [rootscopedev@gmail.com](mailto:rootscopedev@gmail.com)  
2. We’ll add it to the Playground and reply with your SSH connection details

---

## 🧠 Why RootScope?  

Failures rarely happen the way you expect. They can be silent, intermittent, and nearly impossible to reproduce — and when they strike, logs are often missing, rotated, or misleading. Traditional observability assumes you knew what to log ahead of time; RootScope exists for everything you didn’t anticipate.  

Unlike logging and instrumentation, RootScope:  
- Provides a **ground-truth record** that doesn’t depend on prior instrumentation  
- Captures **system-level activity** across processes, files, and devices  
- Is **lightweight and self-contained**, storing data locally without external agents or cloud dependencies  


## 👤 Who Is RootScope For?  

RootScope is designed for **engineers working close to the system**, where traditional logs and observability tools fall short. It’s built for situations where you need answers but your usual signals are missing or misleading.  

- **Platform engineers & infra teams** debugging why `/mnt/data` suddenly unmounted or which process filled `/tmp` before a crash
- **Security engineers & incident responders** investigating *who deleted `/etc/passwd`* or which process opened a sensitive device node  
- **SREs & reliability engineers** reconstructing why a service failed after a newly deployed service raced on a shared file
- **Compliance & Auditting** monitoring what happens to the entire `/etc` directory when something runs to catch misconfigurations, tampering, or policy drift

RootScope is for you if:  
- The process is gone, the file is deleted, and the trail is cold
- You only know *when* something broke — not how or why  
- You’ve hit a failure mode no one instrumented for, and audit rules or journald missed it  
- You need a greppable forensic trail to rewind the system state after the fact


## How It Works

RootScope runs as a privileged user-space daemon that passively monitors system activity by tapping into multiple kernel subsystems via official interfaces — no kernel modules or patches required.
Because interfaces like `fanotify` and `audit` are only accessible to the superuser, RootScope must run with root privileges to receive these low-level event streams safely and reliably.

RootScope captures:

- **File system events** via `fanotify`  
  - Detects file and directory creations, deletions, modifications, and renames
- **Process execution and hierarchy** via `audit` (netlink)  
  - Tracks process lifecycles (fork/exec/exit) and user/group context in real time
  - Builds full process ancestry, even for short-lived or exited processes
- **Device and mount events** via `udev`
  - Detects physical device additions/removals, mount/unmount operations

RootScope then **correlates these events across subsystems** to reconstruct a complete, timestamped view of system state:

- Every file system event is linked back to the process and user that caused it
- Every process is traced through its full parent/child lineage
- All activity is stored locally in a queryable event database stored under `/opt/rootscope/rs.db`

> 📦 RootScope is built entirely in user space with minimal dependencies — no `/proc` scraping, no kernel patching, no eBPF.

## 💬 Questions or Feedback?  

We’d love to hear from you.  

If you have questions, feedback, or run into issues, you can:  
- 📧 Email us at **rootscopedev@gmail.com** (we’ll reply as soon as possible)  
- 🐛 Open an issue directly in this GitHub repo  

Whichever is easier — we’ll be happy to help.  
