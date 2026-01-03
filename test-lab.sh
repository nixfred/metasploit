#!/bin/bash
# P3N73S7 L4B - Full Lab Test Runner
# Run from host (shaggy/box) - tests each container ONE AT A TIME

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PASS=0
FAIL=0

echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  P3N73S7 L4B - SEQUENTIAL TEST RUNNER                     ║"
echo "║  Tests each container one at a time (saves resources)     ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check Docker
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}Docker is not running. Start Docker Desktop first.${NC}"
    exit 1
fi

# Ensure Kali is running (always needed)
echo -e "${CYAN}[INIT] Ensuring Kali is running...${NC}"
docker compose -f "$SCRIPT_DIR/docker-compose.yml" up -d kali 2>/dev/null
sleep 5

# Copy test script to Kali
docker cp "$SCRIPT_DIR/lab-ui/test-all-hacks.sh" kali:/tmp/test-all-hacks.sh 2>/dev/null
docker exec kali chmod +x /tmp/test-all-hacks.sh 2>/dev/null

# Function to test a single container
test_container() {
    local name=$1
    local ip=$2
    local port=$3
    local lesson=$4

    echo -e "\n${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}TESTING: $lesson${NC}"
    echo -e "${CYAN}Container: $name | IP: $ip | Port: $port${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"

    # Start container
    echo -e "${YELLOW}Starting $name...${NC}"
    docker compose -f "$SCRIPT_DIR/docker-compose.yml" up -d "$name" 2>/dev/null

    # Wait for it to be ready
    echo "Waiting 15s for container to initialize..."
    sleep 15

    # Test connectivity from Kali
    echo "Testing connectivity from Kali..."
    if docker exec kali timeout 5 bash -c "echo >/dev/tcp/$ip/$port" 2>/dev/null; then
        echo -e "${GREEN}[PASS] Port $port is open on $ip${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] Port $port not reachable on $ip${NC}"
        ((FAIL++))
    fi

    # Stop container to free resources
    echo -e "${YELLOW}Stopping $name...${NC}"
    docker stop "$name" 2>/dev/null || true
    sleep 3
}

# Function to test HTTP container
test_http_container() {
    local name=$1
    local ip=$2
    local port=$3
    local lesson=$4

    echo -e "\n${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}TESTING: $lesson${NC}"
    echo -e "${CYAN}Container: $name | IP: $ip | Port: $port${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"

    # Start container
    echo -e "${YELLOW}Starting $name...${NC}"
    docker compose -f "$SCRIPT_DIR/docker-compose.yml" up -d "$name" 2>/dev/null

    # Wait for it to be ready (HTTP apps need more time)
    echo "Waiting 20s for container to initialize..."
    sleep 20

    # Test HTTP from Kali
    echo "Testing HTTP connectivity from Kali..."
    http_code=$(docker exec kali curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 "http://$ip:$port/" 2>/dev/null || echo "000")

    if [[ "$http_code" == "200" ]] || [[ "$http_code" == "302" ]] || [[ "$http_code" == "401" ]]; then
        echo -e "${GREEN}[PASS] HTTP responding ($http_code) on $ip:$port${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] HTTP not responding ($http_code) on $ip:$port${NC}"
        ((FAIL++))
    fi

    # Stop container to free resources
    echo -e "${YELLOW}Stopping $name...${NC}"
    docker stop "$name" 2>/dev/null || true
    sleep 3
}

echo -e "\n${CYAN}Starting sequential tests (one container at a time)...${NC}"

# 1. VSFTPD
test_container "vsftpd" "172.20.0.15" "21" "vsftpd-backdoor"

# 2. SSH Bruteforce
test_container "vulnssh" "172.20.0.17" "22" "ssh-bruteforce"

# 3. Tomcat
test_http_container "tomcat" "172.20.0.19" "8080" "tomcat-upload"

# 4. SambaCry
test_container "samba" "172.20.0.16" "445" "sambacry"

# 5. Metasploitable2 DistCC
test_container "metasploitable2" "172.20.0.20" "3632" "metasploitable2-distcc"

# 6 & 7. DVWA (command-injection + sqli)
test_http_container "dvwa" "172.20.0.10" "80" "dvwa-command-injection + sqli-dvwa"

# 8. Juice Shop
test_http_container "juiceshop" "172.20.0.30" "3000" "juiceshop-sqli"

# Summary
echo -e "\n${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}TEST SUMMARY${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}PASSED: $PASS${NC}"
echo -e "${RED}FAILED: $FAIL${NC}"

if [ $FAIL -eq 0 ]; then
    echo -e "\n${GREEN}✓ All hack labs passed connectivity tests!${NC}"
    exit 0
else
    echo -e "\n${RED}✗ Some tests failed - check container logs${NC}"
    exit 1
fi
