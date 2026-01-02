# Lessons Learned

Hard-won knowledge from building P3N73S7 L4B.

## Table of Contents

1. [ttyd Custom index.html Breaks Terminal](#ttyd-custom-indexhtml-breaks-terminal)
2. [Docker BuildKit Keychain Access on macOS](#docker-buildkit-keychain-access-on-macos)
3. [Dynamic URLs for Remote Access](#dynamic-urls-for-remote-access)
4. [Clipboard API Requires HTTPS](#clipboard-api-requires-https)
5. [Metasploit Database in Docker (No Systemd)](#metasploit-database-in-docker-no-systemd)
6. [Tomcat Server Header for MSF Fingerprinting](#tomcat-server-header-for-msf-fingerprinting)
7. [Java Meterpreter vs Shell Payload](#java-meterpreter-vs-shell-payload)
8. [Raw Reverse Shells Have No Prompt](#raw-reverse-shells-have-no-prompt)

---

## ttyd Custom index.html Breaks Terminal

**Date**: 2026-01-02

**Problem**: Kali web terminal at `http://shaggy:7681/` showed light purple background but no prompt. Terminal was completely non-functional when accessed remotely.

**Root Cause**: The ttyd `-I` flag replaces the **entire** default page, including all JavaScript. Our custom `index.html` only had styling and a `<div id="terminal">` but was missing:
- xterm.js library
- ttyd WebSocket client code
- Terminal initialization logic

The default ttyd page is a single inline HTML file with ~50KB of minified JavaScript that handles terminal rendering.

**Bad** (Dockerfile):
```dockerfile
COPY index.html /usr/local/share/ttyd/index.html
CMD ["ttyd", "-W", "-I", "/usr/local/share/ttyd/index.html", "-t", "fontSize=14", "bash"]
```

**Good** (Dockerfile):
```dockerfile
CMD ["ttyd", "-W", "-t", "fontSize=14", "-t", "theme={'background':'#1a1a2e','foreground':'#eee'}", "bash"]
```

**Solution**: Remove `-I` flag entirely. Use ttyd's built-in `-t` options for theming instead of custom HTML.

**Trade-off**: Lost custom favicon, but terminal actually works.

**Future**: If custom favicon is needed, would need to build ttyd's full `inline.html` from source at `https://github.com/tsl0922/ttyd/tree/master/html` which bundles all JS/CSS together.

---

## Docker BuildKit Keychain Access on macOS

**Date**: 2026-01-02

**Problem**: `docker compose build` fails with "keychain cannot be accessed because the current session does not allow user interaction"

**Root Cause**: Docker Desktop on macOS sets `credsStore: "desktop"` in `~/.docker/config.json`. BuildKit tries to access macOS Keychain for credentials, which fails in non-interactive sessions (like Claude Code).

**Solution**: Use legacy builder:
```bash
DOCKER_BUILDKIT=0 docker build -t image-name .
```

Or for docker-compose:
```bash
DOCKER_BUILDKIT=0 docker compose build
```

**Note**: Setting `credsStore: ""` in config.json doesn't fix BuildKit - it hardwires to credential helper regardless.

---

## Dynamic URLs for Remote Access

**Date**: 2026-01-02

**Problem**: Lab UI iframe for Kali terminal was hardcoded to `localhost:7681`. Works locally but fails when accessing Lab UI from another machine (e.g., `http://shaggy:5050`).

**Root Cause**: `localhost` in iframe src refers to the CLIENT machine, not the server.

**Solution**: Use JavaScript to set iframe src dynamically:
```javascript
const terminalUrl = `http://${window.location.hostname}:7681`;
document.getElementById('terminal-frame').src = terminalUrl;
```

Now accessing from any host works - the iframe URL matches the page's hostname.

---

## Clipboard API Requires HTTPS

**Date**: 2026-01-02

**Problem**: COPY buttons in lesson steps don't work when accessing Lab UI remotely via `http://shaggy:5050`.

**Root Cause**: `navigator.clipboard.writeText()` requires a "secure context" - either HTTPS or localhost. Browsers block it on plain HTTP from non-localhost origins.

**Solution**: Add fallback using the older `document.execCommand('copy')` method:
```javascript
if (navigator.clipboard && window.isSecureContext) {
    navigator.clipboard.writeText(text).then(onSuccess);
} else {
    // Fallback for HTTP
    const textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.style.position = 'fixed';
    textarea.style.opacity = '0';
    document.body.appendChild(textarea);
    textarea.select();
    document.execCommand('copy');
    document.body.removeChild(textarea);
    onSuccess();
}
```

**Note**: `execCommand('copy')` is deprecated but still works and is the only option for non-HTTPS.

---

## Metasploit Database in Docker (No Systemd)

**Date**: 2026-01-02

**Problem**: `msfconsole` shows "Database not connected" and `msfdb init` fails silently in Kali container.

**Root Cause**:
1. Docker containers don't run systemd as PID 1
2. `msfdb` tries to use systemctl to start PostgreSQL, which fails
3. PostgreSQL never starts, so msfdb init creates config but can't connect
4. Missing `lsof` package (msfdb dependency)

**Solution**: Update entrypoint.sh to manually start PostgreSQL:
```bash
#!/bin/bash
# Start PostgreSQL (no systemd in container)
service postgresql start
sleep 2

# Initialize msfdb if not done
if [ ! -f /root/.msf4/.db_initialized ]; then
  msfdb init
  touch /root/.msf4/.db_initialized
fi

exec "$@"
```

Also add `lsof` to package list in Dockerfile.

**Key insight**: In Docker, use `service <name> start` not `systemctl start <name>`.

---

## Tomcat Server Header for MSF Fingerprinting

**Date**: 2026-01-02

**Problem**: Metasploit `tomcat_mgr_upload` exploit fails with:
```
[-] Exploit aborted due to failure: not-found: The target server fingerprint "" does not match "(?-mix:Apache.*(Coyote|Tomcat))"
```

**Root Cause**: Modern Tomcat (9.x+) disables the `Server:` header by default for security. Metasploit's fingerprint check expects `Apache-Coyote/1.1` or similar.

**Solution**: Add to Tomcat Dockerfile:
```dockerfile
RUN sed -i 's/<Connector port="8080"/<Connector port="8080" server="Apache-Coyote\/1.1"/' /usr/local/tomcat/conf/server.xml
```

**Quick workaround** (in MSF): `set FingerprintCheck false`

**Note**: For a pentesting lab, we WANT the vulnerable/identifiable configuration. In production, hiding the Server header is a valid hardening measure.

---

## Java Meterpreter vs Shell Payload

**Date**: 2026-01-02

**Problem**: `java/meterpreter/reverse_tcp` payload fails to create a stable session with `tomcat_mgr_upload` exploit.

**Symptoms**:
- Exploit uploads and executes successfully
- "Exploit completed, but no session was created"
- Or session opens briefly then dies

**Solution**: Use `java/shell_reverse_tcp` instead:
```
set PAYLOAD java/shell_reverse_tcp
```

**Why**: Java Meterpreter is more complex and can have issues with:
- JVM version compatibility
- Container/Docker environments
- Non-interactive MSF sessions

The basic Java shell payload is simpler and more reliable. You get a real shell instead of Meterpreter, so use `id`, `whoami`, `cat` instead of `getuid`, `sysinfo`.

---

## Raw Reverse Shells Have No Prompt

**Date**: 2026-01-02

**Problem**: After getting a shell via MSF exploit, there's no prompt. User types commands blindly, doesn't know if they're "in" or what system they're on.

**Why**: Basic reverse shells (like `java/shell_reverse_tcp`) give you a raw socket connection to /bin/sh. No PTY = no prompt, no tab completion, no arrow keys.

**Solution**: Upgrade to interactive bash:
```bash
/bin/bash -i
```

Now you get a real prompt like `root@container:/#`

**Other upgrade options** (if bash -i doesn't work):
```bash
script /dev/null -c bash
python3 -c 'import pty; pty.spawn("/bin/bash")'
python -c 'import pty; pty.spawn("/bin/bash")'
```

**Key insight**: `/bin/bash -i` is most reliable since bash is almost always present. Python may not be installed on minimal containers.

**Lesson**: Always include the shell upgrade step in exploitation lessons. Users need a familiar prompt to know they succeeded.
