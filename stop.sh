#!/usr/bin/env bash
echo "[*] Stopping Open OS VM..."
docker stop open-os-vm 2>/dev/null || true
pkill -f "/tmp/cloudflared tunnel" 2>/dev/null || true
echo "[✓] Open OS VM and web services completely stopped."
