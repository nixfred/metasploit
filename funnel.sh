#!/bin/bash
# Tailscale Funnel Setup for P3N73S7 L4B
# Exposes the lab to the PUBLIC INTERNET via Tailscale Funnel
#
# Prerequisites:
#   1. Tailscale installed and logged in
#   2. MagicDNS enabled: https://login.tailscale.com/admin/dns
#   3. HTTPS enabled: https://login.tailscale.com/admin/dns (HTTPS Certificates section)
#
# Usage:
#   ./funnel.sh start   - Enable Funnel (expose lab to internet)
#   ./funnel.sh stop    - Disable Funnel (close public access)
#   ./funnel.sh status  - Show current Funnel status

set -e

case "$1" in
    start)
        echo "Starting Tailscale Funnel for P3N73S7 L4B..."
        echo ""

        # Reset any existing config
        echo "[1/3] Resetting existing Funnel config..."
        tailscale serve reset 2>/dev/null || true

        # Funnel Lab UI (5050 → 443) - funnel includes serve
        echo "[2/3] Enabling Funnel for Lab UI (localhost:5050 → :443)..."
        tailscale funnel --bg --https=443 http://localhost:5050

        # Funnel Kali terminal (7681 → 8443)
        echo "[3/3] Enabling Funnel for Kali terminal (localhost:7681 → :8443)..."
        tailscale funnel --bg --https=8443 http://localhost:7681

        echo ""
        echo "╔═══════════════════════════════════════════════════════════════╗"
        echo "║  🌐 P3N73S7 L4B is now PUBLIC                                 ║"
        echo "╠═══════════════════════════════════════════════════════════════╣"
        HOSTNAME=$(tailscale status --json | jq -r '.Self.DNSName' | sed 's/\.$//')
        echo "║  Lab UI:   https://$HOSTNAME"
        echo "║  Terminal: https://$HOSTNAME:8443"
        echo "╠═══════════════════════════════════════════════════════════════╣"
        echo "║  Share these URLs with anyone - no Tailscale needed!          ║"
        echo "║  Run './funnel.sh stop' to close public access                ║"
        echo "╚═══════════════════════════════════════════════════════════════╝"
        ;;

    stop)
        echo "Stopping Tailscale Funnel..."

        # Turn off Funnel on both ports
        tailscale funnel --https=443 off 2>/dev/null || true
        tailscale funnel --https=8443 off 2>/dev/null || true

        echo ""
        echo "✅ Funnel disabled. Lab is no longer publicly accessible."
        echo "   Local access still works: http://localhost:5050"
        ;;

    status)
        echo "Tailscale Funnel Status:"
        echo ""
        tailscale serve status
        echo ""
        tailscale funnel status
        ;;

    *)
        echo "Tailscale Funnel for P3N73S7 L4B"
        echo ""
        echo "Usage: $0 {start|stop|status}"
        echo ""
        echo "  start   - Expose lab to the public internet"
        echo "  stop    - Close public access"
        echo "  status  - Show current Funnel configuration"
        echo ""
        echo "Prerequisites:"
        echo "  1. Enable MagicDNS: https://login.tailscale.com/admin/dns"
        echo "  2. Enable HTTPS:    https://login.tailscale.com/admin/dns"
        exit 1
        ;;
esac
