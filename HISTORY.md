# Project History

> Tracking the evolution of the P3N73S7 L4B from concept to reality.

---

## v0.1.0 - The Beginning (Initial Commit)

**Goal:** Create a portable pentesting environment that can be cloned to any Mac.

**What we built:**
- Basic project structure with `msf-dotfiles/` for Metasploit configs
- `install.sh` to symlink configs to `~/.msf4/`
- Initial `docker-compose.yml` with a few vulnerable targets
- Added Metasploit (via Homebrew) as the core tool

**Key insight:** This is NOT a script or app. It's an ENVIRONMENT. Tools are installed manually on each Mac; this repo syncs their CONFIGURATIONS.

---

## v0.2.0 - Arsenal Expansion

**What we added:**
- Hydra integration for brute force attacks
- John the Ripper for password cracking
- SecLists as a Git submodule (wordlists stay small in repo, pull from upstream)
- Expanded docker-compose to 13 vulnerable targets:
  - Web apps: DVWA, bWAPP, Juice Shop, WebGoat, Mutillidae, WordPress
  - Services: vsftpd backdoor, SambaCry, vulnerable SSH, MySQL, Tomcat
  - Honeypot: Cowrie
  - Utility: Dozzle log viewer

**Architecture decision:** Git submodule for SecLists instead of subtree. Keeps our repo at ~1MB instead of 1.5GB. One command updates all wordlists.

---

## v0.3.0 - Kali Attack Box + Lab UI

**The big feature:** Embedded Kali Linux with web-based terminal.

**What we built:**
- `kali/Dockerfile` - Full Kali with Metasploit, Nmap, Hydra, John, SQLMap, Nikto, Gobuster
- ttyd for browser-based terminal access (http://localhost:7681)
- Persistent `/root` directory via Docker volume - survives rebuilds
- `restart: always` - Kali starts automatically with Docker Desktop

**Lab UI (MVP):**
- Flask backend for container management
- Dark hacker-themed interface
- Split-screen: lesson instructions on left, embedded terminal on right
- 4 initial lessons: vsftpd backdoor, SSH brute force, SQL injection, Tomcat upload
- JSON-based lesson system (no database needed for MVP)

**Philosophy:** Clone to new Mac, one-time Docker build, then Kali is always there.

---

## v0.3.5 - Shared Configs

**The duality problem solved:** Same configs on Mac AND Kali.

```
┌─────────────────────────────────────────────────────────────────┐
│                      GIT REPO (MASTER)                          │
│                      msf-dotfiles/                              │
│                        ├── modules/                             │
│                        ├── plugins/                             │
│                        ├── scripts/                             │
│                        └── msfconsole.rc                        │
│                              │                                  │
│              ┌───────────────┴───────────────┐                  │
│              │                               │                  │
│              ▼                               ▼                  │
│   YOUR MAC (symlink)              KALI (docker mount)           │
│   ~/.msf4/ -> msf-dotfiles/       /root/.msf4/* -> msf-dotfiles/│
│                                                                 │
│   EDIT ANYWHERE -> CHANGES GO TO REPO -> GIT TRACKS            │
└─────────────────────────────────────────────────────────────────┘
```

**What gets shared:**
- Custom modules
- Plugins
- Resource scripts (.rc files)
- msfconsole.rc startup config

**What stays local:**
- Database (machine-specific)
- History
- Loot

---

## v0.4.4 - Running Targets Panel (Current)

**Focus:** Container lifecycle visibility and cleanup.

### New Features

1. **Running Targets Panel**
   - Shows all running target containers on welcome page (not Kali)
   - Individual "Stop" button per container
   - "Stop All Targets" button for one-click cleanup
   - Red-themed UI to draw attention to resource usage
   - Auto-hides when no targets are running

2. **New API Endpoint**
   - `/api/targets/stop-all` - stops all target containers in one call

### Files Changed

| File | Change |
|------|--------|
| `lab-ui/app.py` | Added stop-all endpoint |
| `lab-ui/templates/index.html` | Running targets panel + JS |
| `lab-ui/static/style.css` | Red-themed panel styles |

---

## v0.4.3 - UX Polish + vsftpd Fix

**Focus:** UI improvements and vsftpd Dockerfile fix for Debian Bookworm.

### Fixes

1. **vsftpd Dockerfile**
   - Upgraded from `debian:buster-slim` (EOL) to `debian:bookworm-slim`
   - Fixed linker flags: added `-lpam` for PAM library linkage
   - vsftpd backdoor container now builds and runs correctly

2. **Wizard Navigation**
   - "Choose Your Target" now scrolls to top of page instead of bottom

3. **Clickable URLs in Lessons**
   - URLs in step explanations are now auto-linked
   - Added "Open ↗" button next to URLs for one-click access
   - Blue link styling with green hover on buttons

### Files Changed

| File | Change |
|------|--------|
| `targets/vsftpd/Dockerfile` | Bookworm base, `-lpam` linker flag |
| `lab-ui/templates/index.html` | Scroll to top on wizard navigation |
| `lab-ui/templates/lesson.html` | linkifyUrls() function for clickable URLs |
| `lab-ui/static/style.css` | Styles for inline links and open buttons |

---

## v0.4.2 - Docker Image Fixes + ETHOS

**Focus:** Fix broken Docker Hub images, document project philosophy.

### Fixes

1. **Tomcat Image Rebuild**
   - `vulnerables/web-tomcat` image removed from Docker Hub
   - Created `targets/tomcat/Dockerfile` with Tomcat 9 + exposed manager
   - Credentials: tomcat/tomcat, admin/admin
   - MSF exploit: `exploit/multi/http/tomcat_mgr_upload`

2. **WordPress Image Rebuild**
   - `wpscanteam/vulnerablewordpress` image removed from Docker Hub
   - Created `targets/wordpress/Dockerfile` with WordPress 5.4
   - Debug mode enabled, uses vulnmysql for database
   - Admin credentials set during first setup

3. **Docker Compose Cleanup**
   - Removed deprecated `version: '3.8'` attribute
   - Updated Tomcat and WordPress to use `build:` instead of `image:`

### New Documentation

1. **ETHOS.md**
   - Core philosophy: This is an ENVIRONMENT, not an app
   - Design principles: configs in Git, tools on host
   - Clone experience documented
   - Shared config architecture diagram
   - Network isolation policy

### Files Changed

| File | Change |
|------|--------|
| `targets/tomcat/Dockerfile` | New - Tomcat 9 with exposed manager |
| `targets/wordpress/Dockerfile` | New - WordPress 5.4 with debug mode |
| `docker-compose.yml` | Removed version, use build for tomcat/wordpress |
| `ETHOS.md` | New - Project philosophy document |

---

## v0.4.1 - Polish & Fixes

**Focus:** Bug fixes, UX improvements, visual polish.

### Fixes

1. **SSH Password Consistency**
   - Fixed lesson showing `toor` when actual password is `root`
   - Updated ssh-bruteforce.json and docker-compose.yml comment

2. **Container Start/Stop Buttons**
   - Fixed "Start" button not working (Docker credential helper PATH issue)
   - Fixed "Stop Target Container" button (switched from docker-compose stop to docker stop)
   - Added button feedback: "Starting...", "Started!", "Stopping...", "Failed - Retry"

3. **Docker Credential Helper**
   - Added PATH fix directly in app.py run_docker() function
   - No longer depends on shell environment having the PATH set

### New Features

1. **Duration Tags**
   - Added time estimates to lesson steps that take noticeable time
   - Purple stopwatch badge in step header (e.g., "5-10 sec", "1-2 min")
   - Pulsing yellow animation when step is active
   - Purple left border accent on steps with duration

2. **Favicon**
   - Terminal-themed SVG favicon
   - macOS-style traffic light buttons
   - Glowing green `$_` prompt with `(^_^)` kaomoji
   - Animated blinking cursor

3. **Session-Only Step Tracking**
   - Removed localStorage persistence
   - Steps reset on page refresh (cleaner per-session experience)
   - Strikethrough still works during session

4. **Layout Improvement**
   - Side-by-side layout persists until 900px (was 1200px)
   - Better experience on smaller screens

### Files Changed

| File | Change |
|------|--------|
| `lab-ui/app.py` | Docker PATH fix, docker stop, 120s timeout |
| `lab-ui/templates/lesson.html` | Duration tags, button feedback, no localStorage |
| `lab-ui/templates/index.html` | Favicon link |
| `lab-ui/static/style.css` | Duration tag styles, 900px breakpoint |
| `lab-ui/static/favicon.svg` | New terminal-themed favicon |
| `lab-ui/lessons/*.json` | Duration fields added to all 8 lessons |
| `lab-ui/lessons/ssh-bruteforce.json` | Fixed toor -> root |
| `docker-compose.yml` | Fixed vulnssh comment |

---

## v0.4.0 - Wizard UI + Step Tracking + Tailscale

**Major UI Overhaul:** Complete rewrite of Lab UI with wizard-style interface.

### New Features

**1. Wizard Welcome Page**
- ASCII art logo with green glow effect
- Feature cards explaining Kali, Targets, and Lessons
- Live system status checks (Docker running, Kali ready)
- "Choose Your Target" button leads to lesson picker
- Difficulty filter buttons (All, Easy, Medium, Hard)
- Quick access links to Kali terminal and Dozzle

**2. Step Tracking System**
- Progress bar at top of lesson page (sticky while scrolling)
- Three step states: pending, active (current), completed
- Active step has green glow, "CURRENT" badge, pulsing animation
- Completed steps are dimmed with strikethrough title
- Copy button automatically marks step as current
- Checkmark button on each step for manual completion
- Progress saved to localStorage - resume where you left off
- Auto-scroll keeps current step visible

**3. 4 New Lessons** (8 total)
- DVWA Command Injection - OS command injection to reverse shell
- Juice Shop SQL Injection - Modern OWASP SQLi challenge
- SambaCry CVE-2017-7494 - Metasploit CVE exploitation
- Metasploitable2 DistCC - Daemon vulnerability exploitation

**4. Tailscale Remote Access**
- Lab UI on port 5050 (changed from 5000 - macOS AirPlay conflict)
- Kali terminal on port 7681
- Both bound to 0.0.0.0 for Tailscale accessibility
- Target containers stay on 127.0.0.1 for security
- Access from iPad, phone, laptop - anywhere on Tailscale network

**5. Shell Improvements**
- Added `lab` alias to start Lab UI
- Added `kali()` function - starts container if needed, drops into bash
- Added Docker credential helper to PATH (fixes image pull issues)
- All aliases added to ~/.bashrc (synced via Syncthing)

**6. Infrastructure Fixes**
- Port 5050 instead of 5000 (macOS AirPlay Receiver uses 5000)
- Docker credential helper PATH fix for image pulls
- vsftpd custom Dockerfile (old Docker Hub image removed)
- Kali terminal bound to 0.0.0.0 for remote access

### Files Changed/Added

| File | Change |
|------|--------|
| `lab-ui/app.py` | Port 5050, host 0.0.0.0 |
| `lab-ui/templates/index.html` | Complete rewrite - wizard welcome |
| `lab-ui/templates/lesson.html` | Added step tracking system |
| `lab-ui/static/style.css` | +200 lines for wizard and step styles |
| `lab-ui/lessons/dvwa-command-injection.json` | New lesson |
| `lab-ui/lessons/juiceshop-sqli.json` | New lesson |
| `lab-ui/lessons/sambacry.json` | New lesson |
| `lab-ui/lessons/metasploitable2-distcc.json` | New lesson |
| `docker-compose.yml` | vsftpd build, Kali port 0.0.0.0 |
| `targets/vsftpd/Dockerfile` | Custom vsftpd 2.3.4 build |
| `~/.bashrc` | lab alias, kali() function, PATH fix |

---

## Roadmap

### v0.5.0 - Containerized Lab UI (Planned)
- Move Flask app into its own container with nginx
- Single `docker-compose up` starts everything
- No Python/pip needed on host

### v0.6.0 - More Lessons (Planned)
- WebGoat lessons
- bWAPP lessons
- Privilege escalation lessons
- Post-exploitation lessons

### v1.0.0 - Full Learning Platform (Vision)
- SQLite database for multi-user progress
- Lesson completion certificates
- Custom vulnerable containers
- Automated setup scripts for new Macs
- Video walkthroughs embedded in lessons

---

## Architecture Decisions Log

| Decision | Choice | Why |
|----------|--------|-----|
| Wordlist management | Git submodule | Keeps repo small, auto-updates from upstream |
| Kali terminal access | ttyd (web) | Works in browser, no SSH setup needed |
| Kali persistence | Docker volume on /root | Entire home survives rebuilds |
| Lab UI framework | Flask (Python) | Simple, we already have Python, MVP focus |
| Lesson storage | JSON files | No database for MVP, easy to edit |
| Progress tracking | localStorage | No backend needed, works offline |
| Target containers | Pre-built images | Don't maintain vulnerable code ourselves |
| vsftpd container | Custom Dockerfile | Original image removed from Docker Hub |
| Lab UI port | 5050 | macOS uses 5000 for AirPlay Receiver |
| Remote access | 0.0.0.0 binding | Enables Tailscale from any device |

---

## Lessons Learned

1. **Alias conflicts:** `set` is a bash builtin. Named it `settool` instead.
2. **Port conflicts:** macOS Monterey+ uses port 5000. Use 5050 for Flask.
3. **Docker credential helper:** Must add `/Applications/Docker.app/Contents/Resources/bin` to PATH on macOS.
4. **Docker Hub image removal:** Popular vulnerable images get removed. Build from source instead.
5. **Symlink management:** `install.sh` handles linking configs to tool directories.
6. **Persistence matters:** First Docker build is slow; after that it's instant.
7. **Always-on Kali:** With `restart: always`, Kali starts with your Mac.
8. **Progress tracking:** localStorage is perfect for single-user progress - no backend needed.
9. **Tailscale access:** Binding to 0.0.0.0 instead of 127.0.0.1 enables remote access.

---

## Technical Debt

- [ ] Containerize Flask app with nginx
- [ ] Add SQLite for multi-user support
- [ ] Add lesson completion tracking
- [ ] Pre-pull all container images in install.sh
- [ ] Add health checks to docker-compose
- [ ] Add more lessons for remaining targets
- [ ] Create video walkthroughs

---

*Last updated: 2026-01-02*
