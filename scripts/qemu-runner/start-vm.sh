#!/usr/bin/env bash
set -e

ISO_PATH="${ISO_PATH:-/boot.iso}"
RAM_SIZE="${RAM_SIZE:-4G}"
CPU_CORES="${CPU_CORES:-4}"
DISK_PATH="/storage/open-os-disk.qcow2"

echo "[QEMU VM Runner] Initializing Virtual Machine..."
echo "  ISO: $ISO_PATH"
echo "  RAM: $RAM_SIZE | Cores: $CPU_CORES"

if [ ! -f "$DISK_PATH" ]; then
    echo "[*] Creating 30GB virtual disk: $DISK_PATH..."
    qemu-img create -f qcow2 "$DISK_PATH" 30G
fi

# Start noVNC web proxy on port 8006 pointing to VNC :0 (5900)
websockify --web /usr/share/novnc 8006 localhost:5900 &

KVM_FLAG=""
if [ -c /dev/kvm ]; then
    KVM_FLAG="-enable-kvm -cpu host"
    echo "[*] Hardware KVM acceleration enabled."
else
    KVM_FLAG="-cpu qemu64"
    echo "[!] Software virtualization fallback."
fi

# Launch QEMU with VNC display on :0 (port 5900) and Monitor Socket
echo "[*] Booting Virtual Machine..."
exec qemu-system-x86_64 \
    $KVM_FLAG \
    -m "$RAM_SIZE" \
    -smp "$CPU_CORES" \
    -drive file="$DISK_PATH",format=qcow2 \
    -cdrom "$ISO_PATH" \
    -boot d \
    -vga std \
    -vnc :0 \
    -monitor unix:/tmp/qemu-monitor.sock,server,nowait \
    -net nic,model=virtio \
    -net user
