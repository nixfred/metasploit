# Claude Context for Pentesting Learning Lab

This file provides context for Claude (AI assistant) when working on this project.

## Project Overview

**This is a PORTABLE PENTESTING ENVIRONMENT, not an application.**

The goal: Clone this repo on any Mac → run `./install.sh` → entire pentesting setup is restored with all customizations.

### Project Components

| Component | Description |
|-----------|-------------|
| Metasploit Config | Dotfiles that sync MS customizations across machines |
| SET Integration | Social Engineering Toolkit configs and workflows |
| Docker Targets | 13 vulnerable containers for exploitation practice |
| Wordlists | SecLists (submodule) for brute forcing |
| Lab UI | Web interface to launch containers (coming soon) |

### What This Is NOT

- NOT a hacking script to attack real systems
- NOT an application to distribute
- NOT touching any external/internet systems
- NOT for illegal purposes

All attacks target **localhost Docker containers only**.

## Architecture

### Host Machine: shaggy (Mac)

- Metasploit Framework installed via Homebrew (`/opt/metasploit-framework/`)
- SET installed at `~/set/`
- Hydra, John, SQLMap, Nmap, etc. via Homebrew
- Config files live at `~/.msf4/`
- This repo symlinks `msf-dotfiles/` → `~/.msf4/` via `install.sh`

### Secondary Machine: fnix

- Syncthing syncs `.bashrc` FROM fnix TO other machines (including shaggy)
- Aliases like `ms` and `set` are added to fnix's `.bashrc`
- Will eventually clone this repo when it's "GOLD release" ready

### Docker Network

```
172.20.0.0/24 - Lab network
172.20.0.1   - Host (attacker - your Mac)
172.20.0.10  - DVWA
172.20.0.15  - vsftpd (backdoor - easy win)
172.20.0.16  - Samba (SambaCry)
172.20.0.17  - Vuln SSH (brute force with Hydra/John)
172.20.0.18  - Vuln MySQL
172.20.0.19  - Tomcat
172.20.0.20  - Metasploitable2
172.20.0.30  - Juice Shop
172.20.0.40  - WebGoat
172.20.0.50  - Mutillidae
172.20.0.60  - WordPress
172.20.0.70  - bWAPP
172.20.0.100 - Cowrie honeypot
```

## Tools Installed

| Tool | Location | Purpose |
|------|----------|---------|
| Metasploit | `/opt/metasploit-framework/` | Exploitation framework |
| SET | `~/set/` | Social engineering |
| Hydra | `/opt/homebrew/bin/hydra` | Service brute forcing |
| John | `/opt/homebrew/bin/john` | Password hash cracking |
| SQLMap | `/opt/homebrew/bin/sqlmap` | SQL injection |
| Nmap | `/opt/homebrew/bin/nmap` | Port scanning |
| Nikto | `/opt/homebrew/bin/nikto` | Web server scanning |
| Gobuster | `/opt/homebrew/bin/gobuster` | Directory brute force |

## Key Files

| File | Purpose |
|------|---------|
| `install.sh` | Symlinks msf-dotfiles → ~/.msf4 |
| `uninstall.sh` | Removes symlinks, restores backups |
| `docker-compose.yml` | 13 vulnerable target containers |
| `msf-dotfiles/msfconsole.rc` | Auto-run commands on MS startup |
| `msf-dotfiles/modules/` | Custom exploit modules |
| `msf-dotfiles/scripts/` | Resource scripts (.rc files) |
| `docs/CHEATSHEET.md` | Quick exploit commands per target |
| `docs/MS_CUSTOMIZATION.md` | Full Metasploit reference |

## SecLists Submodule

SecLists is linked as a Git submodule - a pointer to the upstream repo:

```
wordlists/seclists/ → github.com/danielmiessler/SecLists
```

- Your repo stays small (~1MB vs 1.5GB)
- Updates from upstream: `git submodule update --remote wordlists/seclists`
- Clone with: `git clone --recursive <repo>`

## What Claude Should Do

### DO:
- Help configure Metasploit settings
- Help write resource scripts for automation
- Help create Docker containers with specific vulnerabilities
- Explain exploit techniques and how they work
- Help build the lab-ui web interface
- Help with SET configurations and workflows
- Add custom modules to msf-dotfiles/modules/
- Improve documentation
- Help with Hydra/John commands

### DO NOT:
- Create exploits for external systems
- Help attack systems the user doesn't own
- Write malware for distribution
- Bypass this project's educational scope
- Push credentials or secrets to the repo

## Common Tasks

### Adding a New Vulnerable Target

1. Add service to `docker-compose.yml`
2. Assign IP in 172.20.0.x range
3. Document ports and vulnerabilities in README
4. Add exploit commands to `docs/CHEATSHEET.md`

### Adding a Custom Module

1. Create `.rb` file in `msf-dotfiles/modules/exploits/` (or auxiliary/, post/, etc.)
2. Follow Metasploit module template
3. Run `reload_all` in msfconsole to load

### Creating Resource Scripts

1. Add `.rc` file to `msf-dotfiles/scripts/`
2. Run in msfconsole: `resource ~/.msf4/scripts/yourscript.rc`

## Shell Aliases

```bash
alias ms='msfconsole'
alias set='sudo python3 ~/set/setoolkit'
```

These are managed via Syncthing from fnix, or can be added directly to ~/.bashrc.

## Git Workflow

This is a private repo at `github.com/nixfred/metasploit`.

```bash
# After making changes
git add -A
git commit -m "Description of changes"
git push

# On new machine
git clone --recursive git@github.com:nixfred/metasploit.git ~/Projects/metasploit
./install.sh
```

## Debugging

### Metasploit won't start
```bash
msfdb reinit   # Reinitialize database
```

### Database not connected
```bash
msfdb start    # Start PostgreSQL
msfconsole -x "db_status"
```

### Docker containers not reachable
```bash
docker network ls
docker network inspect metasploit_lab
ping 172.20.0.10
```

### ms alias not working
```bash
# Either wait for Syncthing to sync from fnix, or add manually:
echo 'alias ms="msfconsole"' >> ~/.bashrc
source ~/.bashrc
```
