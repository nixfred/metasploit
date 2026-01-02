# Pentesting Learning Lab

A complete, portable penetration testing environment for learning offensive security safely and legally. Everything runs locally on your Mac with Docker containers as targets.

---

## REQUIRED: Install These Tools FIRST

**This repo does NOT install tools. It captures their CONFIGURATIONS.**

You must install these before cloning:

### Core Tools (Required)

| Tool | Install Command | Config Captured? |
|------|-----------------|------------------|
| **Metasploit Framework** | `brew install metasploit` | Yes - `msf-dotfiles/` |
| **SET (Social Engineering Toolkit)** | `git clone https://github.com/trustedsec/social-engineer-toolkit.git ~/set && pip3 install --user --break-system-packages -r ~/set/requirements.txt` | Yes - `set-config/` |
| **Docker Desktop** | Download from docker.com | No - just needs to run |
| **Nmap** | `brew install nmap` | No - used via MS |

### Recommended Tools (Optional)

| Tool | Install Command | Purpose |
|------|-----------------|---------|
| SQLMap | `brew install sqlmap` | SQL injection automation |
| Nikto | `brew install nikto` | Web server scanner |
| Gobuster | `brew install gobuster` | Directory brute-forcing |
| **Hydra** | `brew install hydra` | Password/service brute forcing |
| John the Ripper | `brew install john` | Password hash cracking |
| Hashcat | `brew install hashcat` | GPU password cracking |
| Burp Suite | Download from portswigger.net | Web proxy/scanner |
| Wireshark | `brew install wireshark` | Packet analysis |

### Quick Install All (Copy/Paste)

```bash
# Core
brew install metasploit nmap
git clone https://github.com/trustedsec/social-engineer-toolkit.git ~/set
pip3 install --user --break-system-packages -r ~/set/requirements.txt

# Optional but recommended
brew install sqlmap nikto gobuster hydra john hashcat wireshark
```

---

## Project Philosophy

**This is an ENVIRONMENT, not a script or application.**

```
┌────────────────────────────────────────────────────────────────┐
│  Your Mac (tools installed manually)                          │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐          │
│  │Metasploit│ │   SET    │ │  Nmap    │ │  SQLMap  │  ...     │
│  └────┬─────┘ └────┬─────┘ └──────────┘ └──────────┘          │
│       │            │                                           │
│       ▼            ▼                                           │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │           THIS REPO (captures configs)                   │  │
│  │  msf-dotfiles/ ──→ ~/.msf4/                             │  │
│  │  set-config/   ──→ ~/set/config                         │  │
│  │  wordlists/    ──→ SecLists (submodule)                 │  │
│  │  targets/      ──→ Docker vulnerable containers         │  │
│  └─────────────────────────────────────────────────────────┘  │
│                            │                                   │
│           Clone to new Mac = Same customizations               │
└────────────────────────────────────────────────────────────────┘
```

| Component | What's Captured |
|-----------|-----------------|
| Metasploit Config | Custom modules, scripts, msfconsole.rc, plugins |
| SET Integration | SET configs, phishing templates, payload configs |
| Docker Targets | docker-compose.yml, vulnerable containers |
| Wordlists | SecLists (submodule), custom wordlists |

---

## What This Repo Does vs Doesn't Do

### DOES:
- Stores your Metasploit customizations (modules, scripts, settings)
- Stores SET configuration and templates
- Provides docker-compose files for vulnerable targets
- Includes SecLists wordlists (as Git submodule)
- Symlinks configs to the right places via `install.sh`

### DOES NOT:
- Install Metasploit, SET, or other tools
- Check if tools are installed
- Manage tool versions or updates
- Store machine-specific data (DB, loot, history)

---

## Quick Start

```bash
# 1. Install prerequisites (see table above)

# 2. Clone with submodules (includes SecLists)
git clone --recursive git@github.com:nixfred/metasploit.git ~/Projects/metasploit
cd ~/Projects/metasploit

# 3. Link your configs
./install.sh

# 4. Start a target
docker-compose up dvwa -d

# 5. Attack it
msfconsole
# In msf: db_nmap -sV 172.20.0.10
```

### If You Already Cloned Without --recursive

```bash
git submodule init
git submodule update
```

---

## Project Structure

```
metasploit/
├── CLAUDE.md                  # AI assistant context
├── README.md                  # This file
├── install.sh                 # Symlink configs to system locations
├── uninstall.sh               # Remove symlinks
├── docker-compose.yml         # All vulnerable targets
│
├── msf-dotfiles/              # Metasploit configuration
│   ├── msfconsole.rc          # Startup commands
│   ├── modules/               # Custom exploit modules
│   ├── plugins/               # Custom plugins
│   ├── scripts/               # Resource scripts (.rc)
│   └── logos/                 # Custom banners
│
├── set-config/                # SET configuration
│   └── (SET configs here)
│
├── wordlists/                 # SecLists (Git submodule)
│   └── seclists/              # → github.com/danielmiessler/SecLists
│
├── targets/                   # Docker target configurations
│   ├── honeypot/
│   └── custom/
│
├── lab-ui/                    # Web interface (coming soon)
│
└── docs/
    ├── CHEATSHEET.md          # Quick exploit commands per target
    └── MS_CUSTOMIZATION.md    # Detailed MS customization guide
```

---

## SecLists (Wordlists)

SecLists is included as a **Git submodule** - it's linked, not copied.

```bash
# Update SecLists to latest
git submodule update --remote wordlists/seclists

# Common wordlist locations after clone:
wordlists/seclists/Passwords/Common-Credentials/
wordlists/seclists/Discovery/Web-Content/
wordlists/seclists/Fuzzing/
wordlists/seclists/Usernames/
```

### Why Submodule?

- SecLists is ~1.5GB - don't want it in our repo
- Gets updates from upstream
- Your repo stays small
- Users pull it separately

---

## Available Docker Targets

### Web Applications
| Target | IP | Port | Vulnerabilities |
|--------|-----|------|-----------------|
| dvwa | 172.20.0.10 | 8080 | SQLi, XSS, CSRF, Command Injection |
| bwapp | 172.20.0.70 | 8072 | 100+ web vulnerabilities |
| juiceshop | 172.20.0.30 | 3000 | Modern OWASP Top 10 |
| webgoat | 172.20.0.40 | 8081 | Guided OWASP lessons |
| mutillidae | 172.20.0.50 | 8082 | OWASP Top 10 practice |
| vulnerable-wordpress | 172.20.0.60 | 8083 | CMS vulnerabilities |

### Service Exploits (Metasploit targets)
| Target | IP | Service | MSF Module |
|--------|-----|---------|------------|
| vsftpd | 172.20.0.15 | FTP backdoor | `exploit/unix/ftp/vsftpd_234_backdoor` |
| samba | 172.20.0.16 | SambaCry | `exploit/linux/samba/is_known_pipename` |
| vulnssh | 172.20.0.17 | Weak SSH | `auxiliary/scanner/ssh/ssh_login` + Hydra |
| vulnmysql | 172.20.0.18 | Weak MySQL | `auxiliary/scanner/mysql/mysql_login` |
| tomcat | 172.20.0.19 | Manager upload | `exploit/multi/http/tomcat_mgr_upload` |
| metasploitable2 | 172.20.0.20 | Many services | Multiple exploits available |

### Utilities
| Target | IP | Port | Purpose |
|--------|-----|------|---------|
| cowrie | 172.20.0.100 | 2224-2225 | SSH/Telnet honeypot |
| dozzle | - | 9999 | Real-time Docker log viewer |

```bash
docker-compose up dvwa vsftpd -d    # Start specific targets
docker-compose up -d                # Start all
docker-compose down                 # Stop all
```

See `docs/CHEATSHEET.md` for exploit commands for each target.

---

## What Gets Synced vs Ignored

| Synced (version controlled) | NOT Synced (machine-specific) |
|-----------------------------|-------------------------------|
| msfconsole.rc | database.yml |
| modules/ | db/ (PostgreSQL data) |
| plugins/ | loot/ |
| scripts/ | history |
| logos/ | bootsnap_cache/ |
| SET templates | Credentials/keys |

---

## Shell Aliases

Managed via Syncthing from fnix → shaggy:

```bash
alias ms='msfconsole'
alias set='sudo python3 ~/set/setoolkit'
```

---

## Typical Workflow

1. **Pick a vulnerability** to learn (e.g., SQL injection)
2. **Start target**: `docker-compose up dvwa -d`
3. **Scan**: `msfconsole` → `db_nmap -sV 172.20.0.10`
4. **Find vulns**: `vulns`, `services`
5. **Exploit**: `search sqli`, `use exploit/...`
6. **Document**: Take notes
7. **Reset**: `docker-compose down` - evidence destroyed

---

## New Mac Setup Checklist

1. [ ] Install Homebrew
2. [ ] `brew install metasploit nmap`
3. [ ] `brew install sqlmap nikto gobuster hydra john` (optional)
4. [ ] Clone SET: `git clone https://github.com/trustedsec/social-engineer-toolkit.git ~/set`
5. [ ] Install SET deps: `pip3 install --user --break-system-packages -r ~/set/requirements.txt`
6. [ ] Install Docker Desktop
7. [ ] Clone this repo: `git clone --recursive git@github.com:nixfred/metasploit.git`
8. [ ] Run: `./install.sh`
9. [ ] Start hacking: `docker-compose up dvwa -d && msfconsole`

---

## Legal Notice

This repository is for **educational purposes only**. All attacks target:
- Localhost Docker containers you control
- Intentionally vulnerable images
- Systems you own or have explicit written permission to test

Never use these techniques against systems without authorization.
