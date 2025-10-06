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

> 📦 RootScope is built entirely in user space with minimal dependencies — no `/proc` scraping, no kernel patching, no eBPF.

---

## ⚙️ Installation

RootScope can be installed in one step using **curl** — no manual downloads required.

### 🧩 Supported Distributions

Fully tested:
- **Ubuntu** 22.04 LTS / 24.04 / 25.04  
- **Debian** 11 (Bullseye) / 12 (Bookworm)  
- Other **systemd-based** distributions may work, but are not officially supported yet.

---

### 🚀 1. Download the package for your distro

Run the command that matches your system:

```bash
# Debian 12
curl -L -o rootscope_1.1.5-1.debian12_amd64.deb \
https://github.com/RootScopeInc/RootScope/releases/download/1.1.5/rootscope_1.1.5-1.debian12_amd64.deb

# Debian 11
curl -L -o rootscope_1.1.5-1.debian11_amd64.deb \
https://github.com/RootScopeInc/RootScope/releases/download/1.1.5/rootscope_1.1.5-1.debian11_amd64.deb

# Ubuntu 22
curl -L -o rootscope_1.1.5-1.ubuntu22.04_amd64.deb \
https://github.com/RootScopeInc/RootScope/releases/download/1.1.5/rootscope_1.1.5-1.ubuntu22.04_amd64.deb

# Ubuntu 24
curl -L -o rootscope_1.1.5-1.ubuntu24.04_amd64.deb \
https://github.com/RootScopeInc/RootScope/releases/download/1.1.5/rootscope_1.1.5-1.ubuntu24.04_amd64.deb

# Ubuntu 25
curl -L -o rootscope_1.1.5-1.ubuntu25.04_amd64.deb \
https://github.com/RootScopeInc/RootScope/releases/download/1.1.5/rootscope_1.1.5-1.ubuntu25.04_amd64.deb
```

> 💡 **Tip:** The latest builds are available on the [Releases Page](https://github.com/RootScopeInc/RootScope/releases).  
> Match the `.deb` filename to your distro version.


### 📦 2. Install the RootScope daemon

Install the downloaded package:

```
sudo apt install ./rootscope_*.deb --fix-missing --fix-broken
```

This will:
- Install the RootScope daemon
- Set up the rsctl CLI
- Enable and start the daemon on boot

> RootScope requires root privileges to install and run the system daemon.

### 🧠 3. Verify installation

Run the following to confirm that everything is set up correctly:

```bash
rsctl -h
```

You’ll see a list of available commands, examples, and usage help.

---

## 🧪 Try RootScope via a RootScope Playground

If you’re not on one of the supported distros, you can try RootScope in the Playground — a zero-setup environment that lets you explore it right away.

It simulates real system activity and shows how RootScope captures events that typical logging tools overlook.

No installation, no setup — just SSH in and start experimenting.

### 🔐 How to Access the Playground

1. Send your **public SSH key** to [rootscopedev@gmail.com](mailto:rootscopedev@gmail.com)  
2. We’ll add it to the Playground and reply with your SSH connection details

---

## 💬 Questions or Feedback?  

We’d love to hear from you.  

If you have questions, feedback, or run into issues, you can:  
- 📧 Email us at **rootscopedev@gmail.com** (we’ll reply as soon as possible)  
- 🐛 Open an issue directly in this GitHub repo  

Whichever is easier — we’ll be happy to help.  
