#!/usr/bin/env bash
# ==============================================================================
# Open OS - Setup & Transformation Script for Existing Kali Linux
# Run this inside any Kali Linux VM or Bare-Metal installation to convert it into Open OS.
# Usage: sudo bash setup-on-existing-kali.sh
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config/open-os.conf"

COLOR_CYAN="\033[1;36m"
COLOR_GREEN="\033[1;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_RED="\033[1;31m"
COLOR_RESET="\033[0m"

echo -e "${COLOR_CYAN}"
echo "=============================================================="
echo "         Open OS (Kali Edition) Setup & Conversion            "
echo "=============================================================="
echo -e "${COLOR_RESET}"

if [ "$(id -u)" -ne 0 ]; then
    echo -e "${COLOR_RED}[!] Error: This script must be run as root (use sudo).${COLOR_RESET}"
    exit 1
fi

if [ -f "$CONFIG_FILE" ]; then
    # shellcheck disable=SC1090
    source "$CONFIG_FILE"
    echo -e "${COLOR_GREEN}[✓] Loaded configuration from: $CONFIG_FILE${COLOR_RESET}"
fi

# Step 1: Add 32-bit architecture for Wine
echo -e "\n${COLOR_CYAN}[1/7] Enabling multi-arch for Windows compatibility...${COLOR_RESET}"
dpkg --add-architecture i386 || true
apt-get update -y

# Step 2: Install Base & Desktop Packages
echo -e "\n${COLOR_CYAN}[2/7] Installing Open OS Desktop & Wayland Components...${COLOR_RESET}"
if [ -f "$SCRIPT_DIR/config/packages.desktop.list" ]; then
    grep -v '^#' "$SCRIPT_DIR/config/packages.desktop.list" | grep -v '^$' | xargs apt-get install -y --no-install-recommends || true
fi

# Step 3: Install Compatibility Packages (Waydroid & Wine)
echo -e "\n${COLOR_CYAN}[3/7] Installing Multi-Platform Compatibility Packages...${COLOR_RESET}"
if [ -f "$SCRIPT_DIR/config/packages.compatibility.list" ]; then
    grep -v '^#' "$SCRIPT_DIR/config/packages.compatibility.list" | grep -v '^$' | xargs apt-get install -y || true
fi

# Step 4: Configure Kernel Modules for Waydroid (Binder)
echo -e "\n${COLOR_CYAN}[4/7] Setting up Android Kernel Binder Modules...${COLOR_RESET}"
modprobe binder_linux || true
echo "binder_linux" > /etc/modules-load.d/open-os-binder.conf || true

# Step 5: Install Open OS Core Executables & Configuration
echo -e "\n${COLOR_CYAN}[5/7] Deploying Open OS Core Binaries...${COLOR_RESET}"
mkdir -p /etc/open-os
cp -f "$CONFIG_FILE" /etc/open-os/open-os.conf

install -m 755 "$SCRIPT_DIR/core/bin/open-os" /usr/local/bin/open-os
install -m 755 "$SCRIPT_DIR/core/bin/open-os-apk-installer" /usr/local/bin/open-os-apk-installer
install -m 755 "$SCRIPT_DIR/core/bin/open-os-exe-launcher" /usr/local/bin/open-os-exe-launcher
install -m 755 "$SCRIPT_DIR/core/bin/open-os-pentest-bridge" /usr/local/bin/open-os-pentest-bridge

# Step 6: Install Desktop MIME Associations
echo -e "\n${COLOR_CYAN}[6/7] Registering File Associations (.apk, .exe, .msi)...${COLOR_RESET}"
cp -f "$SCRIPT_DIR/core/desktop-entries/"*.desktop /usr/share/applications/
update-desktop-database /usr/share/applications/ 2>/dev/null || true

# Step 7: Initialize Subsystems if requested
echo -e "\n${COLOR_CYAN}[7/7] Initializing Subsystems...${COLOR_RESET}"
if [ "$ENABLE_ANDROID_ENGINE" = "true" ] && command -v waydroid >/dev/null 2>&1; then
    echo -e "${COLOR_GREEN}[*] Setting up Waydroid container service...${COLOR_RESET}"
    systemctl enable waydroid-container || true
fi

echo -e "\n${COLOR_GREEN}==============================================================${COLOR_RESET}"
echo -e "${COLOR_GREEN}   [✓] Open OS Setup Complete! Ready for Multi-Platform Apps   ${COLOR_RESET}"
echo -e "${COLOR_GREEN}==============================================================${COLOR_RESET}"
echo -e "You can now run: ${COLOR_CYAN}open-os status${COLOR_RESET} or ${COLOR_CYAN}open-os doctor${COLOR_RESET}"
