# Claude Context for Pentesting Learning Lab

This file provides context for Claude (AI assistant) when working on this project.

## Project Overview

This is a **private learning environment** for penetration testing. The owner is learning Metasploit, SET, and offensive security using local Docker containers as targets.

### Project Breakdown

| Component | Weight | Description |
|-----------|--------|-------------|
| Metasploit Config | 40% | Dotfiles that sync MS customizations across machines |
| Docker Target UI | 40% | Web interface to launch vulnerable containers |
| SET Integration | 20% | Social Engineering Toolkit workflows |

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
- Config files live at `~/.msf4/`
- This repo symlinks `msf-dotfiles/` → `~/.msf4/` via `install.sh`

### Secondary Machine: fnix

- Syncthing syncs `.bashrc` FROM fnix TO other machines (including shaggy)
- Aliases like `ms` and `set` are added to fnix's `.bashrc`
- Will eventually clone this repo when it's "GOLD release" ready

### Docker Network

```
172.20.0.0/24 - Lab network
172.20.0.1   - Host (attacker)
172.20.0.10  - DVWA
172.20.0.20  - Metasploitable2
172.20.0.30  - Juice Shop
... etc
```

## Key Files

| File | Purpose |
|------|---------|
| `install.sh` | Symlinks msf-dotfiles → ~/.msf4 |
| `uninstall.sh` | Removes symlinks, restores backups |
| `docker-compose.yml` | All vulnerable target containers |
| `msf-dotfiles/msfconsole.rc` | Auto-run commands on MS startup |
| `msf-dotfiles/modules/` | Custom exploit modules |
| `msf-dotfiles/scripts/` | Resource scripts (.rc files) |

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
4. Update lab-ui if it exists

### Adding a Custom Module

1. Create `.rb` file in `msf-dotfiles/modules/exploits/` (or auxiliary/, post/, etc.)
2. Follow Metasploit module template
3. Run `reload_all` in msfconsole to load

### Creating Resource Scripts

1. Add `.rc` file to `msf-dotfiles/scripts/`
2. Run in msfconsole: `resource ~/.msf4/scripts/yourscript.rc`

## Metasploit Key Concepts

### Global Options (setg)
Persist across module changes within a session:
```
setg RHOSTS 172.20.0.0/24
setg LHOST 172.20.0.1
```

### msfconsole.rc
Runs on every msfconsole startup. Good for:
- Setting globals
- Loading plugins
- Custom prompt
- Workspace setup

### Database Commands
```
db_status          # Check PostgreSQL connection
db_nmap            # Scan and store in DB
hosts              # List discovered hosts
vulns              # List discovered vulns
services           # List discovered services
workspace          # Manage workspaces
```

## SET Key Concepts

SET (Social Engineering Toolkit) is for social engineering attacks:
- Credential harvesting (fake login pages)
- Phishing (email campaigns)
- Website attack vectors
- Payload generation

SET config lives at `/etc/setoolkit/set.config` (or can be overridden).

SET integrates with Metasploit for payload delivery and handler setup.

## Future Plans

1. **Lab UI**: Web interface at `lab-ui/` to:
   - List available targets with vulnerability info
   - One-click container launch/stop
   - Show target status and IPs
   - Integrate SET attack options

2. **SET Configs**: Store SET configuration in `set-config/`

3. **Learning Notes**: Track attack playbooks in `docs/`

## Git Workflow

This is a private repo at `github.com/nixfred/metasploit`.

```bash
# After making changes
git add -A
git commit -m "Description of changes"
git push

# On new machine
git clone git@github.com:nixfred/metasploit.git ~/Projects/metasploit
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
