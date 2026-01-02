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

## Roadmap

### v0.4.0 - Containerized Lab UI (Planned)
- Move Flask app into its own container with nginx
- Single `docker-compose up` starts everything
- No Python/pip needed on host

### v0.5.0 - Progress Tracking (Planned)
- SQLite database for user progress
- Track completed lessons, captured flags
- Session history

### v1.0.0 - Full Learning Platform (Vision)
- More lessons covering OWASP Top 10
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
| Target containers | Pre-built images | Don't maintain vulnerable code ourselves |

---

## Lessons Learned

1. **Alias conflicts:** `set` is a bash builtin. Named it `settool` instead.
2. **Symlink management:** `install.sh` handles linking configs to tool directories.
3. **Persistence matters:** First Docker build is slow; after that it's instant.
4. **Always-on Kali:** With `restart: always`, Kali starts with your Mac.

---

*Last updated: 2026-01-02*
