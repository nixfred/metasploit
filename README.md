# Pentesting Learning Lab

A complete, portable penetration testing environment for learning offensive security safely and legally. Everything runs locally on your Mac with Docker containers as targets.

## Project Philosophy

**This is an ENVIRONMENT, not a script or application.**

| Component | Weight | Purpose |
|-----------|--------|---------|
| Metasploit Config | 40% | Portable dotfiles for MS customizations across machines |
| Docker Target UI | 40% | Web interface to spin up vulnerable containers |
| SET Integration | 20% | Social Engineering Toolkit configs and workflows |

## What This Repository Does

1. **Syncs your pentesting tool configs** - Clone on a new Mac, run install script, you're back where you were
2. **Provides vulnerable targets** - Docker containers with intentional vulnerabilities
3. **Keeps everything legal** - All attacks happen on localhost, never touch external systems
4. **Offers a web UI** - Pick vulnerabilities, launch targets, track progress (coming soon)

## Prerequisites

```bash
# macOS
brew install metasploit

# SET (Social Engineering Toolkit)
git clone https://github.com/trustedsec/social-engineer-toolkit.git ~/set
pip3 install --user --break-system-packages -r ~/set/requirements.txt

# Docker Desktop must be installed and running
```

## Quick Start

```bash
# Clone the repo
git clone git@github.com:nixfred/metasploit.git ~/Projects/metasploit
cd ~/Projects/metasploit

# Link your configs
./install.sh

# Start a target
docker-compose up dvwa -d

# Launch Metasploit (or use 'ms' alias)
msfconsole

# In msfconsole:
db_nmap -sV 172.20.0.10
```

## Project Structure

```
metasploit/
├── msf-dotfiles/              # [40%] Metasploit configuration
│   ├── msfconsole.rc          # Auto-run commands on startup
│   ├── modules/               # Custom exploit modules (.rb)
│   ├── plugins/               # Custom plugins
│   ├── scripts/               # Resource scripts (.rc)
│   └── logos/                 # Custom banners
│
├── set-config/                # [20%] SET configuration
│   └── set.config             # SET settings (coming soon)
│
├── targets/                   # Docker target configs
│   ├── metasploitable/
│   ├── dvwa/
│   ├── vulnhub/
│   ├── honeypot/
│   └── custom/
│
├── lab-ui/                    # [40%] Web interface (coming soon)
│   ├── index.html
│   └── ...
│
├── docs/
│   └── MS_CUSTOMIZATION.md    # Metasploit customization guide
│
├── docker-compose.yml         # All vulnerable targets
├── install.sh                 # Symlink configs to ~/.msf4
├── uninstall.sh               # Remove symlinks
└── CLAUDE.md                  # Context for AI assistants
```

## Available Docker Targets

| Target | IP | Port(s) | Vulnerabilities |
|--------|-----|---------|-----------------|
| dvwa | 172.20.0.10 | 8080 | SQLi, XSS, CSRF, File Upload |
| metasploitable2 | 172.20.0.20 | 2221-22445 | FTP, SSH, SMB, Telnet, HTTP |
| juiceshop | 172.20.0.30 | 3000 | OWASP Top 10 (100+ vulns) |
| webgoat | 172.20.0.40 | 8081 | Guided OWASP lessons |
| mutillidae | 172.20.0.50 | 8082 | OWASP Top 10 practice |
| vulnerable-wordpress | 172.20.0.60 | 8083 | CMS vulnerabilities |
| cowrie (honeypot) | 172.20.0.100 | 2224-2225 | SSH/Telnet honeypot |

### Start Individual Targets

```bash
docker-compose up dvwa -d           # Web app vulns
docker-compose up metasploitable2 -d # Classic exploits
docker-compose up juiceshop -d      # Modern OWASP
docker-compose down                  # Stop all
```

## What Gets Synced vs Ignored

| Synced (in repo) | NOT Synced (machine-specific) |
|------------------|-------------------------------|
| modules/ | database.yml |
| plugins/ | db/ (PostgreSQL data) |
| scripts/ | loot/ |
| logos/ | history |
| msfconsole.rc | bootsnap_cache/ |

## Shell Aliases

These aliases are managed via Syncthing from fnix:

```bash
alias ms='msfconsole'                      # Metasploit console
alias set='sudo python3 ~/set/setoolkit'   # SET requires sudo
```

## Metasploit Customization Quick Reference

See `docs/MS_CUSTOMIZATION.md` for full details.

### Key Files

| File | Purpose |
|------|---------|
| `~/.msf4/msfconsole.rc` | Commands run on every startup |
| `~/.msf4/modules/` | Your custom modules |
| `~/.msf4/database.yml` | PostgreSQL connection (local) |

### Useful Global Options

```ruby
# In msfconsole.rc or live:
setg RHOSTS 172.20.0.0/24    # Default target range
setg LHOST 172.20.0.1        # Your attack IP
setg Prompt [%T] msf         # Custom prompt with timestamp
setg ConsoleLogging true     # Log all sessions
```

## Typical Learning Workflow

1. **Pick a vulnerability to learn** (e.g., SQL injection)
2. **Start the appropriate target**: `docker-compose up dvwa -d`
3. **Scan it**: `db_nmap -sV 172.20.0.10`
4. **Find and exploit vulns**: `search sqli`, `use exploit/...`
5. **Take notes** in your preferred format
6. **Destroy and repeat**: `docker-compose down`

## SET Integration

SET attacks that work well with Docker targets:

- **Credential Harvester** - Clone target login pages
- **Website Attack Vectors** - Java applet, HTA attacks
- **QR Code Generator** - Phishing links

SET attacks requiring real infrastructure (not Docker):
- Mass mailer (needs SMTP)
- Wireless attacks (needs WiFi adapter)

## Legal Notice

This repository is for **educational purposes only**. All attacks target:
- Localhost containers you control
- Intentionally vulnerable images
- Systems you own or have explicit permission to test

Never use these techniques against systems without authorization.

## Contributing

This is a private learning repo. As you learn:
1. Add custom modules to `msf-dotfiles/modules/`
2. Create resource scripts in `msf-dotfiles/scripts/`
3. Document findings in `docs/`
4. Commit and push to sync across machines
