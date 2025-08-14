# RootScope

**RootScope** is a Linux black box recorder for postmortem root cause analysis and real-time system forensics.

It continuously captures system activity at the kernel level — including file system changes, device events, and process execution — and reconstructs a searchable, timestamped timeline. Even when logs are missing, rotated, or incomplete, RootScope helps you trace exactly what happened.

---

## 🧠 Why RootScope?

Logs can be tampered with, rotated, or incomplete. Field issues are impossible to reproduce.

RootScope exists to make postmortem debugging less guesswork — by recording the ground truth directly from the kernel.

Unlike traditional observability tools, RootScope:
- Works even when logs are missing, incomplete, or wiped
- Records system-level activity — bypassing the logging paradigm entirely
- Is lightweight and self-contained, storing everything locally without external agents or cloud dependencies

## 👤 Who Is RootScope For?

RootScope is designed for **engineers working close to the system**, where traditional logs and observability tools fall short. It's ideal for:

- **Platform engineers & infra teams** tracing filesystem, mount, or device changes
- **Security engineers & incident responders** who need visibility even when logs are wiped or tampered with
- **Embedded Linux developers** debugging field-only failures and boot-time issues
- **SREs & reliability engineers** running postmortems with missing or rotated logs
- **Anyone investigating** system state changes with no clear trace of "what happened"

RootScope is for you if:
- The process is gone, the file is deleted, and the trail is cold
- You only know *when* the failure occurred — not why
- You encounter a system failure you didn’t anticipate, and audit rules or journald missed it
- You need a reliable, greppable forensic trail long after the fact

---

## 🚀 Key Use Cases

- Find the root cause of system failures after the fact
- Reconstruct what changed on the system and who did it
- Detect transient bugs and timing issues that logs missed
- Investigate security-related events like unexpected file or device access

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

## ⚙️ Installation

This repository contains the daemon package installer for RootScope.

### 🧩 Supported Distros

- Ubuntu 22.04+ (tested and supported)
- Other Linux distributions with systemd may work, but are not officially supported yet

> RootScope requires root privileges to install and run the system daemon.

### 📦 Install the RootScope daemon

RootScope is designed to install with a single command and start working immediately — no configuration required.


```bash
sudo apt install ./rootscope_1.1.1_amd64.deb --fix-missing --fix-broken
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

## 🧪 Try RootScope via a RootScope Playground

The RootScope Playground is a zero-setup environment designed to let you try RootScope instantly.

It walks you through a fun, real-world scenario — the kind that traditional logging tools miss — and shows how RootScope helps uncover the full picture.

No install, no configuration — just SSH in and start investigating.

### 🔐 How to Access the Playground

You can simply use the SSH key `rootscope_playground.pem` attached in this repository and run:

```bash
chmod 600 rootscope_playground.pem
ssh -i rootscope_playground.pem ubuntu@44.199.189.108
```

You’ll land in the RootScope Playground environment immediately.

> ⚠️ This private key is intentionally published for public access to the RootScope Playground.  
> It only grants access to a single isolated VM with no persistent state.  
> Do **not** reuse this key for anything else.

---

## 💬 Questions or Feedback?

We’d love to hear from you.

If you have questions, feedback, or run into issues, feel free to reach out anytime:

📧 **rootscopedev@gmail.com**  
We’ll get back to you as soon as possible.
