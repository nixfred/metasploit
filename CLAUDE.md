# Claude Context for Pentesting Learning Lab

This file provides context for Claude (AI assistant) when working on this project.

## Project Overview

**This is a PORTABLE PENTESTING ENVIRONMENT, not an application.**

The goal: Clone this repo on any Mac -> run `./install.sh` -> entire pentesting setup is restored with all customizations.

### What This Is

| Component | Description |
|-----------|-------------|
| Metasploit Config | Dotfiles that sync MS customizations across machines |
| SET Integration | Social Engineering Toolkit configs and workflows |
| Docker Targets | 13 vulnerable containers for exploitation practice |
| Wordlists | SecLists (submodule) for brute forcing |
| Lab UI | Flask web interface with wizard-style lessons and embedded Kali terminal |
| Kali Attack Box | Persistent Kali container with web terminal (always running) |

### What This Is NOT

- NOT a hacking script to attack real systems
- NOT an application to distribute
- NOT touching any external/internet systems
- NOT for illegal purposes

All attacks target **localhost Docker containers only**.

---

## Quick Reference (For Future You)

### Three Commands to Remember

```bash
source ~/.bashrc     # Load aliases after opening new terminal
lab                  # Start Lab UI at http://localhost:5050
kali                 # Drop into Kali attack box
```

### Three URLs to Remember

| URL | What |
|-----|------|
| http://localhost:5050 | Lab UI - Wizard with guided lessons |
| http://localhost:7681 | Kali Terminal - Full Kali in browser |
| http://localhost:9999 | Dozzle - Docker log viewer |

### Tailscale Remote Access

From any device on your Tailscale network:
- `http://<tailscale-ip>:5050` - Lab UI
- `http://<tailscale-ip>:7681` - Kali Terminal

---

## Architecture

### Host Machine: shaggy (Mac)

- Metasploit Framework installed via Homebrew (`/opt/metasploit-framework/`)
- SET installed at `~/set/`
- Hydra, John, SQLMap, Nmap, etc. via Homebrew
- Config files live at `~/.msf4/`
- This repo symlinks `msf-dotfiles/` -> `~/.msf4/` via `install.sh`

### Secondary Machine: fnix

- Syncthing syncs `.bashrc` FROM fnix TO other machines (including shaggy)
- Aliases like `ms`, `lab`, and `kali()` function are in fnix's `.bashrc`
- Will eventually clone this repo when it's "GOLD release" ready

### Docker Network

```
172.20.0.0/24 - Lab network
172.20.0.1   - Host (attacker - your Mac)
172.20.0.5   - Kali attack box (web terminal at localhost:7681)
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

### Port Bindings

| Service | Host Port | Binding | Notes |
|---------|-----------|---------|-------|
| Lab UI | 5050 | 0.0.0.0 | Flask app, Tailscale accessible |
| Kali Terminal | 7681 | 0.0.0.0 | ttyd, Tailscale accessible |
| DVWA | 8080 | 127.0.0.1 | Local only |
| Juice Shop | 3000 | 127.0.0.1 | Local only |
| WebGoat | 8081 | 127.0.0.1 | Local only |
| Dozzle | 9999 | 127.0.0.1 | Local only |

**Note:** Port 5000 is used by macOS AirPlay Receiver. That's why Lab UI uses 5050.

---

## Lab UI Details

### Tech Stack

- **Backend:** Flask (Python) on port 5050
- **Frontend:** Vanilla HTML/CSS/JS (no frameworks)
- **Styling:** Dark hacker theme with CSS variables
- **Data:** JSON files for lessons (no database)
- **Terminal:** Embedded iframe to ttyd on port 7681

### File Locations

```
lab-ui/
├── app.py                 # Flask backend
├── requirements.txt       # Just Flask
├── templates/
│   ├── index.html         # Wizard welcome page
│   └── lesson.html        # Lesson page with step tracking
├── static/
│   └── style.css          # All styles (~900 lines)
└── lessons/               # JSON lesson definitions (8 total)
    ├── vsftpd-backdoor.json
    ├── ssh-bruteforce.json
    ├── sqli-dvwa.json
    ├── tomcat-upload.json
    ├── dvwa-command-injection.json
    ├── juiceshop-sqli.json
    ├── sambacry.json
    └── metasploitable2-distcc.json
```

### Key Features

1. **Wizard Welcome Page** (index.html)
   - ASCII art logo
   - Feature overview (Kali, Targets, Lessons)
   - System status checks (Docker, Kali, targets)
   - Lesson picker with difficulty filters

2. **Lesson Page with Step Tracking** (lesson.html)
   - Split screen: instructions left, Kali terminal right
   - Progress bar (sticky at top)
   - Step states: pending, active (current), completed
   - Copy button auto-marks step as current
   - Checkmark button for manual completion
   - Progress persists in localStorage
   - Auto-scroll to current step

3. **API Endpoints** (app.py)
   - `GET /` - Main wizard page
   - `GET /lesson/<id>` - Individual lesson
   - `POST /api/container/<name>/start` - Start container
   - `POST /api/container/<name>/stop` - Stop container
   - `GET /api/container/<name>/status` - Get status
   - `GET /api/containers/status` - All container statuses
   - `POST /api/kali/start` - Start Kali

### Lesson JSON Structure

```json
{
  "id": "vsftpd-backdoor",
  "name": "vsftpd 2.3.4 Backdoor",
  "difficulty": "easy",
  "container": "vsftpd",
  "ip": "172.20.0.15",
  "port": 21,
  "short_description": "One-liner shown in cards",
  "description": "Full description shown in lesson",
  "steps": [
    {
      "title": "Step title",
      "command": "Command to copy",
      "explanation": "Why we're doing this",
      "expected": "What you should see"
    }
  ],
  "success_criteria": "How to know you succeeded",
  "next_steps": ["What to try next"]
}
```

---

## Shell Configuration

### Aliases in ~/.bashrc

```bash
# Quick Metasploit
alias ms='msfconsole'

# SET (NOT 'set' - conflicts with bash builtin!)
alias settool='cd ~/set && sudo python3 setoolkit'

# Lab UI - starts Flask on port 5050
alias lab='cd ~/Projects/metasploit/lab-ui && python3 app.py'

# Docker credential helpers (fixes image pull issues on macOS)
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin"

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
```

---

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

---

## Key Files

| File | Purpose |
|------|---------|
| `install.sh` | Symlinks msf-dotfiles -> ~/.msf4 |
| `uninstall.sh` | Removes symlinks, restores backups |
| `docker-compose.yml` | 13 targets + Kali + Dozzle |
| `kali/Dockerfile` | Kali attack box with ttyd web terminal |
| `targets/vsftpd/Dockerfile` | Custom vsftpd 2.3.4 build (old image removed from Docker Hub) |
| `lab-ui/app.py` | Flask backend for Lab UI (port 5050) |
| `lab-ui/templates/index.html` | Wizard welcome page |
| `lab-ui/templates/lesson.html` | Lesson page with step tracking |
| `lab-ui/static/style.css` | Dark hacker theme |
| `lab-ui/lessons/*.json` | 8 lesson definitions |
| `HISTORY.md` | Project evolution log |
| `msf-dotfiles/msfconsole.rc` | Auto-run commands on MS startup |
| `msf-dotfiles/modules/` | Custom exploit modules |
| `msf-dotfiles/scripts/` | Resource scripts (.rc files) |
| `docs/CHEATSHEET.md` | Quick exploit commands per target |
| `docs/MS_CUSTOMIZATION.md` | Full Metasploit reference |

---

## SecLists Submodule

SecLists is linked as a Git submodule - a pointer to the upstream repo:

```
wordlists/seclists/ -> github.com/danielmiessler/SecLists
```

- Your repo stays small (~1MB vs 1.5GB)
- Updates from upstream: `git submodule update --remote wordlists/seclists`
- Clone with: `git clone --recursive <repo>`

---

## Docker Volume Mounts

The Kali container has three types of storage:

```yaml
volumes:
  # 1. Named volume for persistence (survives rebuilds)
  - kali-home:/root

  # 2. Bind mount for shared Metasploit configs
  - ./msf-dotfiles:/root/.msf4

  # 3. Bind mount for wordlists (read-only)
  - ./wordlists:/root/wordlists:ro
```

**Important:** The bind mounts overlay on top of the named volume. This means:
- `/root/.msf4/` = your repo's `msf-dotfiles/` (synced via Git)
- `/root/wordlists/` = your repo's `wordlists/` (read-only)
- Everything else in `/root/` = persistent Docker volume

---

## What Claude Should Do

### DO:
- Help configure Metasploit settings
- Help write resource scripts for automation
- Help create Docker containers with specific vulnerabilities
- Explain exploit techniques and how they work
- Help build/improve the lab-ui web interface
- Help with SET configurations and workflows
- Add custom modules to msf-dotfiles/modules/
- Improve documentation
- Help with Hydra/John commands
- Add new lessons (JSON files)
- Fix bugs in the Flask app or frontend
- Improve step tracking and UI/UX

### DO NOT:
- Create exploits for external systems
- Help attack systems the user doesn't own
- Write malware for distribution
- Bypass this project's educational scope
- Push credentials or secrets to the repo

---

## Common Tasks

### Adding a New Vulnerable Target

1. Add service to `docker-compose.yml`
2. Assign IP in 172.20.0.x range
3. Document ports and vulnerabilities in README
4. Add exploit commands to `docs/CHEATSHEET.md`
5. Create a lesson in `lab-ui/lessons/`

### Adding a New Lesson

1. Create `lab-ui/lessons/<id>.json`
2. Follow the JSON structure (see above)
3. Set `container` to match docker-compose service name
4. Set `ip` to match the container's static IP
5. Include clear step-by-step commands

### Adding a Custom Metasploit Module

1. Create `.rb` file in `msf-dotfiles/modules/exploits/` (or auxiliary/, post/, etc.)
2. Follow Metasploit module template
3. Run `reload_all` in msfconsole to load

### Creating Resource Scripts

1. Add `.rc` file to `msf-dotfiles/scripts/`
2. Run in msfconsole: `resource ~/.msf4/scripts/yourscript.rc`

---

## Architecture Decisions

### Why Flask on port 5050?
Port 5000 is used by macOS AirPlay Receiver since Monterey. We use 5050 to avoid conflicts.

### Why no database for Lab UI?
MVP doesn't need it. Lessons are JSON files, easy to edit. Progress tracking uses localStorage. v2 could add SQLite for multi-user support.

### Why Flask on host instead of containerized?
For MVP, simpler. The Flask app needs Docker socket access to manage containers. v2 could containerize with nginx/gunicorn.

### Why persistent Kali home directory?
The entire `/root` is a Docker volume. This means:
- Shell history persists
- Metasploit database persists
- Custom tools/scripts survive rebuilds
- Only first build is slow; after that Kali is always ready

### Why `restart: always` on Kali?
With Docker Desktop auto-starting on login, Kali becomes a permanent member of your Mac. Open `http://localhost:7681` anytime and it's there.

### Why bind mounts for msf-dotfiles and wordlists?
Git becomes the single source of truth. Edit configs on Mac or in Kali, changes go to the repo, git tracks everything.

### Why custom vsftpd Dockerfile?
The old `vulnerables/vsftpd-2.3.4` image was removed from Docker Hub. We now build from the infected source at `targets/vsftpd/Dockerfile`.

### Why 0.0.0.0 binding for Lab UI and Kali terminal?
To enable Tailscale remote access. Target containers stay on 127.0.0.1 for security - only accessible from Kali.

---

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
source ~/.bashrc
```

---

## Debugging

### Lab UI won't start
```bash
# Check if port 5050 is in use
lsof -i :5050

# Check Flask errors
cd ~/Projects/metasploit/lab-ui
python3 app.py
```

### Docker images won't pull
```bash
# Docker credential helper issue - add to PATH
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin"

# Then retry
docker-compose pull
```

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

### Kali container won't start
```bash
docker-compose logs kali
docker-compose up -d --force-recreate kali
```

### Step tracking not working
- Check browser console for JavaScript errors
- Clear localStorage: `localStorage.clear()`
- Hard refresh: Cmd+Shift+R

---

## Version History

See `HISTORY.md` for detailed project evolution.

Current version: **v0.4.0** - Wizard UI with step tracking and Tailscale support.
