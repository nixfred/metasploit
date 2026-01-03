# P3N73S7 L4B - TODO

Tracking what works and what needs polish.

---

## Lessons Status

| Lesson | Container | Builds | Starts from UI | Exploit Works | Ends on # Prompt | pwn Script |
|--------|-----------|--------|----------------|---------------|------------------|------------|
| vsftpd-backdoor | vsftpd | ✅ | ✅ | ✅ | ✅ | ✅ |
| tomcat-upload | tomcat | ✅ | ✅ | ✅ | ✅ | ✅ |
| ssh-bruteforce | vulnssh | ? | ? | ? | ? | ❌ |
| sqli-dvwa | dvwa | ? | ? | ? | ? | ❌ |
| dvwa-command-injection | dvwa | ? | ? | ? | ? | ❌ |
| juiceshop-sqli | juiceshop | ? | ? | ? | ? | ❌ |
| sambacry | samba | ? | ? | ? | ? | ❌ |
| metasploitable2-distcc | metasploitable2 | ? | ? | ? | ? | ❌ |

**Legend:** ✅ = Tested and working | ❌ = Not done | ? = Needs testing

---

## Quality Bar for Each Lesson

Every lesson must:

1. **Container builds on fresh clone** - `docker compose build <name>` works
2. **Container starts from UI** - Click "Start" button works
3. **Exploit chain works end-to-end** - All steps execute successfully
4. **User ends on `root@container:#` prompt** - Not a blinking cursor
5. **Instructions clear about no-prompt** - "Just type!" warning on first shell command
6. **pwn script exists** - `pwn <target>` automation for after learning

---

## UI Fixes Needed

- [x] "Back to Lessons" → goes to lesson picker, not landing page
- [x] Docker status says "Not Running" (not "Start Docker Desktop")
- [ ] Funnel toggle on website (nice-to-have)

---

## Documentation Needed

- [ ] Document clone → build → run workflow for fresh Mac
- [ ] Document Ubuntu support (if any differences)
- [ ] Add LESSONS_LEARNED.md entries as issues arise

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

**Key insight:** Containers build on first use. The `docker compose build` step compiles vsftpd from source, builds Kali, etc. This is automatic but takes time on first run.

---

## Next Lesson to Polish

Pick ONE, test end-to-end, update lesson JSON, add pwn script if missing.

Current focus: **vsftpd-backdoor** (DONE) → next: **ssh-bruteforce**
