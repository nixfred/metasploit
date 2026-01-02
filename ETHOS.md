# P3N73S7 L4B - Project Ethos

> This document captures the core philosophy and design principles that guide this project.

---

## The Core Insight

**This is NOT an application. This is an ENVIRONMENT.**

The fundamental realization: pentesting setups are personal, evolving, and deeply customized over time. You don't want to rebuild from scratch every time you get a new Mac or need to sync between machines.

This repo is a **portable pentesting environment** that:
- Clones to any Mac
- Syncs CONFIGURATIONS (not tools)
- Restores your entire setup in one command

---

## What This Project IS

```
┌─────────────────────────────────────────────────────────────────┐
│                    GIT REPO (MASTER)                            │
│                                                                 │
│  Your customizations, configs, resource scripts, and lessons   │
│                                                                 │
│         Clone → Run install.sh → Everything works              │
└─────────────────────────────────────────────────────────────────┘
```

- **Config sync hub**: Metasploit configs, resource scripts, custom modules
- **Local lab network**: 13+ vulnerable Docker targets on isolated 172.20.0.0/24
- **Learning platform**: Guided lessons with embedded terminal
- **Kali attack box**: Always-on container with web terminal

## What This Project is NOT

- NOT a hacking script to attack real systems
- NOT an application to distribute
- NOT touching any external/internet systems
- NOT for illegal purposes

**All attacks target localhost Docker containers only.**

---

## Design Principles

### 1. Tools Stay on Host, Configs Live in Git

Tools are installed manually on each Mac (via Homebrew):
```bash
brew install metasploit nmap hydra john-jumbo sqlmap
```

This repo syncs their **configurations**:
```
msf-dotfiles/
├── msfconsole.rc      # Startup commands
├── modules/           # Custom exploits
├── scripts/           # Resource scripts (.rc files)
└── plugins/           # MSF plugins
```

**Why?** Tool binaries are large, architecture-specific, and auto-update. Configs are small, portable, and the real value-add.

### 2. Git Submodules for Large Dependencies

SecLists (1.5GB of wordlists) is a submodule, not embedded:
```
wordlists/seclists/ → github.com/danielmiessler/SecLists
```

**Benefits:**
- Repo stays at ~1MB instead of 1.5GB
- One command updates: `git submodule update --remote`
- Always get latest wordlists from upstream

### 3. Docker for Targets, Not Attack Tools

Vulnerable targets run in Docker:
- Isolated network (172.20.0.0/24)
- No external exposure (bound to localhost)
- Easy teardown and reset

Attack tools run on the host (or in Kali container) with direct network access.

### 4. Kali as Always-On Companion

The Kali container (`restart: always`) starts automatically with Docker Desktop:
- Web terminal at http://localhost:7681
- Survives reboots, always ready
- `/root` persisted via Docker volume
- Shares configs with host Mac via volume mounts

### 5. JSON Lessons, No Database

For the MVP, lessons are JSON files:
```json
{
  "id": "vsftpd-backdoor",
  "name": "vsftpd 2.3.4 Backdoor",
  "difficulty": "easy",
  "steps": [...]
}
```

**Why JSON?**
- Easy to edit and version control
- No database setup for new clones
- Shareable between users

### 6. Build From Source When Images Disappear

Docker Hub images get removed. When they do, we build our own:
```
targets/
├── vsftpd/Dockerfile      # vsftpd 2.3.4 backdoor
├── tomcat/Dockerfile      # Tomcat with exposed manager
└── wordpress/Dockerfile   # Vulnerable WordPress
```

This ensures the lab keeps working even when upstream images vanish.

---

## The Clone Experience

What happens when you clone to a new Mac:

```bash
# 1. Clone with submodules
git clone --recursive git@github.com:nixfred/metasploit.git ~/Projects/metasploit

# 2. Install tools (one-time, manual)
brew install metasploit nmap hydra john-jumbo sqlmap

# 3. Symlink configs
cd ~/Projects/metasploit
./install.sh

# 4. Start the lab
docker-compose up -d kali
open http://localhost:7681    # Kali terminal
open http://localhost:5050    # Lab UI
```

**First run**: Docker builds images (slow, ~10 min)
**Every run after**: Instant startup

---

## Shared Config Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      GIT REPO (MASTER)                          │
│                      msf-dotfiles/                              │
│                              │                                  │
│              ┌───────────────┴───────────────┐                  │
│              │                               │                  │
│              ▼                               ▼                  │
│   YOUR MAC (symlink)              KALI (docker mount)           │
│   ~/.msf4/ → msf-dotfiles/       /root/.msf4 → msf-dotfiles/    │
│                                                                 │
│   EDIT ANYWHERE → CHANGES GO TO REPO → GIT TRACKS              │
└─────────────────────────────────────────────────────────────────┘
```

**What gets shared:**
- Custom modules, plugins, resource scripts
- msfconsole.rc startup config
- Aliases and shell configs (via Syncthing)

**What stays local:**
- Database (machine-specific PostgreSQL)
- Command history
- Loot and scan results

---

## Network Isolation

All targets bind to `127.0.0.1`:
```yaml
ports:
  - "127.0.0.1:8080:80"   # ONLY accessible from localhost
```

The only exception is Kali terminal bound to `0.0.0.0:7681` for Tailscale access.

This means:
- No accidental exposure of vulnerable containers
- Safe to run on coffee shop WiFi
- Tailscale lets you access Lab UI remotely (your devices only)

---

## Evolution, Not Revolution

This project grows incrementally:

| Version | Focus |
|---------|-------|
| v0.1.0 | Basic structure, symlink configs |
| v0.2.0 | Docker targets, SecLists submodule |
| v0.3.0 | Kali attack box, Lab UI MVP |
| v0.4.x | Polish, fixes, more lessons |
| v0.5.0 | Containerize Lab UI |
| v1.0.0 | Multi-user support, video walkthroughs |

Each version should leave the project in a working state. No half-finished features.

---

## Guiding Questions

When making changes, ask:

1. **Does this belong in Git?**
   - Configs: YES
   - Tool binaries: NO
   - Large datasets: SUBMODULE

2. **Does this work on a fresh clone?**
   - Test with clean Docker and fresh repo

3. **Is this localhost only?**
   - Never expose vulnerable targets to the network

4. **Will this survive Docker Hub changes?**
   - If an image might disappear, build from source

5. **Does the user need to install anything?**
   - Minimize host dependencies
   - Document what's required

---

## The Philosophy in One Sentence

> Clone the repo, run install.sh, and your entire pentesting setup appears exactly as you left it.

---

*Last updated: 2026-01-02*
