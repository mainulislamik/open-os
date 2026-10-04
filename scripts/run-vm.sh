#!/usr/bin/env bash
# ==============================================================================
# Open OS - VM Runner (Docker + QEMU KVM with Web VNC)
# Runs the generated Open OS ISO inside a KVM accelerated Virtual Machine
# Usage: ./scripts/run-vm.sh [path_to_iso]
# ==============================================================================

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Auto-detect built ISO
DEFAULT_ISO=$(ls -1 "$REPO_ROOT/iso-builder/output/"*.iso 2>/dev/null | head -n 1)
ISO_PATH="${1:-$DEFAULT_ISO}"

if [ -z "$ISO_PATH" ] || [ ! -f "$ISO_PATH" ]; then
    echo "[!] Error: No ISO file found at: $ISO_PATH"
    echo "    Please wait for the build process to complete or specify a valid ISO path."
    exit 1
fi

echo "[*] Preparing Open OS Virtual Machine environment..."
echo "    Target ISO: $ISO_PATH"
echo "    Allocating: 4GB RAM, 4 CPU Cores, KVM Hardware Acceleration"

# Create a virtual hard disk for persistent testing if not exists
VM_STORAGE_DIR="$REPO_ROOT/vm-data"
mkdir -p "$VM_STORAGE_DIR"

# Clean up any existing container
docker rm -f open-os-vm 2>/dev/null || true

# Run QEMU runner
echo "[*] Starting VM container on port 8006 (Web VNC) and port 5900 (VNC)..."
docker run -d --name open-os-vm \
    --device /dev/kvm \
    --cap-add NET_ADMIN \
    -p 8006:8006 \
    -p 5900:5900 \
    -v "$ISO_PATH:/boot.iso:ro" \
    -v "$VM_STORAGE_DIR:/storage" \
    -e RAM_SIZE="4G" \
    -e CPU_CORES="4" \
    qemu-runner-openos

echo "[✓] Virtual Machine launched successfully!"
echo "    Access Web Viewer at: http://localhost:8006/vnc.html"
echo "    Access Native VNC at: localhost:5900"
