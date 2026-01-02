#!/bin/bash
# P3N73S7 L4B Launcher
# Ensures Kali is running before starting the Lab UI

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KALI_READY=false

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  🔓 P3N73S7 L4B - Starting...                             ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Check Docker is running
echo "[1/3] Checking Docker..."
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop."
    exit 1
fi
echo "✅ Docker is running"
echo ""

# Check/start Kali
echo "[2/3] Checking Kali Attack Box..."
if docker ps --format '{{.Names}}' | grep -q '^kali$'; then
    echo "✅ Kali is already running"
    KALI_READY=true
else
    echo "⚠️  Kali is not running. Starting now..."
    cd "$PROJECT_DIR"

    # Add Docker credential helper to PATH
    export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin"

    if docker compose up -d kali 2>/dev/null || docker-compose up -d kali 2>/dev/null; then
        echo "⏳ Waiting for Kali to initialize..."
        sleep 3

        if docker ps --format '{{.Names}}' | grep -q '^kali$'; then
            echo "✅ Kali is now running"
            KALI_READY=true
        else
            echo "❌ Kali failed to start. Check logs:"
            echo "   docker logs kali"
            exit 1
        fi
    else
        echo "❌ Failed to start Kali. Check Docker Compose configuration."
        exit 1
    fi
fi
echo ""

# Start Lab UI
echo "[3/3] Starting Lab UI..."
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  🔓 P3N73S7 L4B                                           ║"
echo "║  Open http://localhost:5050 in your browser               ║"
echo "║  Kali terminal at http://localhost:7681                   ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

cd "$PROJECT_DIR/lab-ui"
python3 app.py
