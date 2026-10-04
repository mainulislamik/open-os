#!/usr/bin/env bash
# ==============================================================================
# Open OS - Robust Containerized Live-Build Entrypoint
# Uses Kali Linux official live-build-config architecture
# ==============================================================================

set -e

echo "[Open OS ISO Builder] Initializing Kali Live-Build environment..."

WORK_DIR="/build/live-build-config"
if [ ! -d "$WORK_DIR" ]; then
    echo "[*] Cloning official Kali live-build-config template..."
    git clone --depth 1 https://gitlab.com/kalilinux/build-scripts/live-build-config.git "$WORK_DIR"
fi

cd "$WORK_DIR"

# Inject Open OS custom package lists into Kali configuration
echo "[*] Injecting Open OS packages into common package lists..."
TARGET_PKG_DIR="$WORK_DIR/kali-config/common/package-lists"
mkdir -p "$TARGET_PKG_DIR"

cat /build/config/packages.kali.list \
    /build/config/packages.compatibility.list \
    /build/config/packages.desktop.list 2>/dev/null > "$TARGET_PKG_DIR/open-os.list.chroot" || true

# Inject Open OS core binaries and desktop integration
TARGET_OVERLAY="$WORK_DIR/kali-config/common/includes.chroot"
mkdir -p "$TARGET_OVERLAY/usr/local/bin"
mkdir -p "$TARGET_OVERLAY/etc/open-os"
mkdir -p "$TARGET_OVERLAY/usr/share/applications"

cp -f /build/core/bin/* "$TARGET_OVERLAY/usr/local/bin/" || true
cp -f /build/config/open-os.conf "$TARGET_OVERLAY/etc/open-os/" || true
cp -f /build/core/desktop-entries/* "$TARGET_OVERLAY/usr/share/applications/" || true
chmod +x "$TARGET_OVERLAY/usr/local/bin/"* || true

mkdir -p /build/output

echo "[*] Building Open OS ISO (Variant: xfce, Branch: kali-rolling)..."
./build.sh --branch kali-rolling --variant xfce --output /build/output

if ls /build/output/*.iso >/dev/null 2>&1; then
    echo "[✓] ISO built successfully! Saved to: /build/output/"
    ls -lh /build/output/*.iso
else
    echo "[!] Build script ended. Check logs for details."
fi
