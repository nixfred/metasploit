# P3N73S7 L4B - TODO

**v1.0.0 GOLD RELEASE - All lessons tested and working!**

---

## Lessons Status

| Lesson | Container | Builds | Starts from UI | Exploit Works | Ends on # Prompt | pwn Script |
|--------|-----------|--------|----------------|---------------|------------------|------------|
| vsftpd-backdoor | vsftpd | ✅ | ✅ | ✅ | ✅ | ✅ `pwn vsftpd` |
| ssh-bruteforce | vulnssh | ✅ | ✅ | ✅ | ✅ | ✅ `pwn ssh` |
| tomcat-upload | tomcat | ✅ | ✅ | ✅ | ✅ | ✅ `pwn tomcat` |
| sambacry | samba | ✅ | ✅ | ✅ | ✅ | ✅ `pwn sambacry` |
| metasploitable2-distcc | metasploitable2 | ✅ | ✅ | ✅ | ✅ | ✅ `pwn distcc` |
| sqli-dvwa | dvwa | ✅ | ✅ | ✅ | N/A | N/A (web-based) |
| dvwa-command-injection | dvwa | ✅ | ✅ | ✅ | N/A | N/A (web-based) |
| juiceshop-sqli | juiceshop | ✅ | ✅ | ✅ | N/A | N/A (web-based) |

**Legend:** ✅ = Tested and working | N/A = Not applicable (web-based lesson)

---

## Quality Bar for Each Lesson ✅

Every lesson must:

1. ✅ **Container builds on fresh clone** - `docker compose build <name>` works
2. ✅ **Container starts from UI** - Click "Start" button works
3. ✅ **Exploit chain works end-to-end** - All steps execute successfully
4. ✅ **User ends on `root@container:#` prompt** - Not a blinking cursor (for shell exploits)
5. ✅ **Instructions clear about no-prompt** - "Just type!" warning on first shell command
6. ✅ **pwn script exists** - `pwn <target>` automation for shell exploits

---

## UI Fixes ✅

- [x] "Back to Lessons" → goes to lesson picker, not landing page
- [x] Docker status says "Not Running" (not "Start Docker Desktop")
- [x] COPY button works with commands containing quotes
- [ ] Funnel toggle on website (nice-to-have, v1.1.0)

---

## Documentation ✅

- [x] Clone → build → run workflow documented in README.md
- [x] LESSONS_LEARNED.md with 8 detailed entries
- [ ] Document Ubuntu support (if any differences) - v1.1.0

---

## Fresh Clone Workflow

When someone clones this repo on a new Mac:

```bash
# 1. Clone with submodules
git clone --recursive git@github.com:nixfred/metasploit.git ~/Projects/metasploit
cd ~/Projects/metasploit

# 2. Install host tools (one-time)
brew install metasploit nmap hydra john-jumbo sqlmap

# 3. Link configs
./install.sh

# 4. Build Kali (one-time, ~15 min)
docker compose up kali -d

# 5. Build targets as needed (or all at once)
docker compose build           # Build all custom targets
docker compose pull            # Pull pre-built images

# 6. Start Lab
source ~/.bashrc
lab
```

---

## v1.1.0 Roadmap

- [ ] Funnel toggle on website
- [ ] Containerize Flask app with nginx
- [ ] Document Ubuntu support
- [ ] Add WebGoat lessons
- [ ] Add bWAPP lessons
