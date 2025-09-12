# RootScope  

**RootScope** is a Linux black box recorder — a source of truth for system activity. It runs entirely in userspace, leveraging kernel primitives like **audit netlink**, **udev**, and **fanotify** to capture file, process, and device events in real time. These raw signals are automatically correlated into a searchable, timestamped timeline that traces every event back to its origin.  

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


---

## 🔧 How It Works

RootScope runs as a privileged user-space daemon that passively monitors system activity by tapping into multiple kernel subsystems via official interfaces — no kernel modules or patches required.

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

> 📦 RootScope is built entirely in user space — no `/proc` scraping, no kernel patching, no eBPF.

---

## 🧪 Try RootScope via a RootScope Playground

The RootScope Playground is a zero-setup environment designed to let you try RootScope instantly.

It walks you through a fun, real-world scenario — the kind that traditional logging tools miss — and shows how RootScope helps uncover the full picture.

No install, no configuration — just SSH in and start investigating.

### 🔐 How to Access the Playground  

Getting access is simple:  

1. Send your **public SSH key** to [rootscopedev@gmail.com](mailto:rootscopedev@gmail.com)  
2. We’ll add it to the Playground and send you the login details  

That’s it — no setup, no install. You’ll land directly in the RootScope Playground environment and can start exploring right away.

---

## ⚙️ Installation

If you prefer a more hands on trial, you can pick the installer that matches your distro version under [`installers/`](./installers/):

> Tip: We keep the latest builds in the `installers/` directory. Check the filenames for the exact distro and version.

### 🧩 Supported Distros

The following distros are fully tested:
- Ubuntu 22.04+
- Debian 11 and 12
- Other Linux distributions with systemd may work, but are not officially supported yet

> RootScope requires root privileges to install and run the system daemon.

### 📦 Install the RootScope daemon

RootScope is designed to install with a single command and start working immediately — no configuration required.


```
sudo apt update && sudo apt install <pkg> --fix-missing --fix-broken
```

This will:
- Install the RootScope system daemon
- Set up the rsctl CLI interface
- Enable and start the daemon on boot

Once installed, run:

```bash
rsctl -h
```

to view all the available commands as well as their example usage


---

## 💬 Questions or Feedback?  

We’d love to hear from you.  

If you have questions, feedback, or run into issues, you can:  
- 📧 Email us at **rootscopedev@gmail.com** (we’ll reply as soon as possible)  
- 🐛 Open an issue directly in this GitHub repo  

Whichever is easier — we’ll be happy to help.  
