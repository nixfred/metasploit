#!/bin/bash
# P3N73S7 L4B - Automated Hack Tester
# Runs connectivity tests and pwn commands for all lessons

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

PASS=0
FAIL=0
SKIP=0

log_pass() { echo -e "${GREEN}[PASS]${NC} $1"; ((PASS++)); }
log_fail() { echo -e "${RED}[FAIL]${NC} $1"; ((FAIL++)); }
log_skip() { echo -e "${YELLOW}[SKIP]${NC} $1"; ((SKIP++)); }
log_info() { echo -e "${CYAN}[INFO]${NC} $1"; }
log_test() { echo -e "\n${CYAN}═══════════════════════════════════════${NC}"; echo -e "${CYAN}TESTING: $1${NC}"; }

# Test if a port is open
test_port() {
    local ip=$1
    local port=$2
    timeout 5 bash -c "echo >/dev/tcp/$ip/$port" 2>/dev/null
}

# Test HTTP response
test_http() {
    local url=$1
    curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$url" 2>/dev/null
}

echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  P3N73S7 L4B - AUTOMATED HACK TESTER                      ║"
echo "║  Testing all 8 lessons                                     ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# ============================================================
# 1. VSFTPD BACKDOOR
# ============================================================
log_test "vsftpd-backdoor (172.20.0.15:21)"

if test_port 172.20.0.15 21; then
    log_pass "FTP port 21 is open"

    # Test pwn command (non-interactive check)
    log_info "Running: pwn vsftpd (checking if script exists)"
    if command -v pwn &>/dev/null || [ -f /root/.msf4/scripts/pwn ]; then
        log_pass "pwn command available"
    else
        log_skip "pwn command not in PATH"
    fi
else
    log_fail "FTP port 21 not reachable"
fi

# ============================================================
# 2. SSH BRUTEFORCE
# ============================================================
log_test "ssh-bruteforce (172.20.0.17:22)"

if test_port 172.20.0.17 22; then
    log_pass "SSH port 22 is open"

    # Quick SSH banner grab
    banner=$(timeout 3 bash -c "echo '' | nc 172.20.0.17 22" 2>/dev/null | head -1)
    if [[ "$banner" == *"SSH"* ]]; then
        log_pass "SSH banner: $banner"
    else
        log_info "Could not grab SSH banner"
    fi
else
    log_fail "SSH port 22 not reachable"
fi

# ============================================================
# 3. TOMCAT UPLOAD
# ============================================================
log_test "tomcat-upload (172.20.0.19:8080)"

if test_port 172.20.0.19 8080; then
    log_pass "Tomcat port 8080 is open"

    # Check manager interface
    http_code=$(test_http "http://172.20.0.19:8080/manager/html")
    if [[ "$http_code" == "401" ]]; then
        log_pass "Tomcat Manager returns 401 (auth required) - expected"
    elif [[ "$http_code" == "200" ]]; then
        log_pass "Tomcat Manager accessible"
    else
        log_info "Tomcat Manager returned: $http_code"
    fi
else
    log_fail "Tomcat port 8080 not reachable"
fi

# ============================================================
# 4. SAMBACRY
# ============================================================
log_test "sambacry (172.20.0.16:445)"

if test_port 172.20.0.16 445; then
    log_pass "SMB port 445 is open"

    # Check SMB with smbclient if available
    if command -v smbclient &>/dev/null; then
        shares=$(smbclient -L //172.20.0.16 -N 2>/dev/null | grep -c "Disk" || echo "0")
        log_info "Found $shares SMB shares"
    fi
else
    log_fail "SMB port 445 not reachable"
fi

# ============================================================
# 5. METASPLOITABLE2 DISTCC
# ============================================================
log_test "metasploitable2-distcc (172.20.0.20:3632)"

if test_port 172.20.0.20 3632; then
    log_pass "DistCC port 3632 is open"
else
    log_fail "DistCC port 3632 not reachable"
fi

# Also check other common Metasploitable2 ports
for port in 21 22 23 80; do
    if test_port 172.20.0.20 $port; then
        log_info "Metasploitable2 port $port also open"
    fi
done

# ============================================================
# 6. DVWA COMMAND INJECTION
# ============================================================
log_test "dvwa-command-injection (172.20.0.10:80)"

if test_port 172.20.0.10 80; then
    log_pass "DVWA port 80 is open"

    http_code=$(test_http "http://172.20.0.10/")
    if [[ "$http_code" == "200" ]] || [[ "$http_code" == "302" ]]; then
        log_pass "DVWA HTTP responding ($http_code)"
    else
        log_info "DVWA returned: $http_code"
    fi
else
    log_fail "DVWA port 80 not reachable"
fi

# ============================================================
# 7. SQLI DVWA (same container as #6)
# ============================================================
log_test "sqli-dvwa (172.20.0.10:80)"

if test_port 172.20.0.10 80; then
    log_pass "DVWA port 80 is open (shared with command-injection)"
    log_skip "SQLi requires browser session - manual test only"
else
    log_fail "DVWA port 80 not reachable"
fi

# ============================================================
# 8. JUICE SHOP SQLI
# ============================================================
log_test "juiceshop-sqli (172.20.0.30:3000)"

if test_port 172.20.0.30 3000; then
    log_pass "Juice Shop port 3000 is open"

    http_code=$(test_http "http://172.20.0.30:3000/")
    if [[ "$http_code" == "200" ]]; then
        log_pass "Juice Shop HTTP responding"
    else
        log_info "Juice Shop returned: $http_code"
    fi
    log_skip "SQLi login bypass requires browser - manual test only"
else
    log_fail "Juice Shop port 3000 not reachable"
fi

# ============================================================
# SUMMARY
# ============================================================
echo -e "\n${CYAN}═══════════════════════════════════════${NC}"
echo -e "${CYAN}TEST SUMMARY${NC}"
echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo -e "${GREEN}PASSED: $PASS${NC}"
echo -e "${RED}FAILED: $FAIL${NC}"
echo -e "${YELLOW}SKIPPED: $SKIP${NC}"

if [ $FAIL -eq 0 ]; then
    echo -e "\n${GREEN}✓ All connectivity tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}✗ Some tests failed - check containers${NC}"
    exit 1
fi
