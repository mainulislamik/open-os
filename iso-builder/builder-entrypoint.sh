#!/usr/bin/env bash
# ==============================================================================
# Open OS - Containerized Live-Build Entrypoint
# ==============================================================================

set -e

echo "[Open OS ISO Builder] Starting Kali Live-Build environment..."

WORK_DIR="/build/live-build-workspace"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# Copy custom package lists from config
mkdir -p config/package-lists
cat /build/config/packages.kali.list \
    /build/config/packages.compatibility.list \
    /build/config/packages.desktop.list 2>/dev/null > config/package-lists/open-os.list.chroot || true

# Copy hooks and chroot overlays (Core binaries, etc.)
mkdir -p config/includes.chroot/usr/local/bin
mkdir -p config/includes.chroot/etc/open-os
mkdir -p config/includes.chroot/usr/share/applications

cp -f /build/core/bin/* config/includes.chroot/usr/local/bin/ || true
cp -f /build/config/open-os.conf config/includes.chroot/etc/open-os/ || true
cp -f /build/core/desktop-entries/* config/includes.chroot/usr/share/applications/ || true

chmod +x config/includes.chroot/usr/local/bin/* || true

# Configure live-build
lb config \
    --distribution kali-rolling \
    --archive-areas "main contrib non-free non-free-firmware" \
    --architectures amd64 \
    --image-name "open-os-kali" \
    --bootloader grub-efi \
    --system live

echo "[Open OS ISO Builder] Initiating binary image build..."
lb build

# Output will be located in $WORK_DIR/*.iso
if ls "$WORK_DIR"/*.iso >/dev/null 2>&1; then
    cp -v "$WORK_DIR"/*.iso /build/output/
    echo "[✓] ISO built successfully! Saved to output directory."
else
    echo "[!] Build finished. Inspect $WORK_DIR for build logs."
fi
