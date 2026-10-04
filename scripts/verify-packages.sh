#!/usr/bin/env bash
apt-get update -qq

pkgs=(
    waydroid lxc dnsmasq iptables nftables kmod curl ca-certificates python3-gbinder wl-clipboard
    wine wine64 cabextract 7zip fuse3 libfuse3-4 python3-pip python3-venv python3-requests
    kali-desktop-xfce weston sway swaylock swayidle waybar wofi foot alacritty pipewire pipewire-pulse
    wireplumber mesa-utils mesa-va-drivers vulkan-tools zenity yad libnotify-bin thunar thunar-archive-plugin
    file-roller kali-linux-core kali-tools-top10 kali-tools-web adb fastboot apktool jadx zipalign
    apksigner dex2jar ghidra radare2 gdb ltrace strace binwalk hexedit burpsuite zaproxy wireshark
    tshark tcpdump nmap netcat-traditional mitmproxy metasploit-framework sqlmap nikto responder
    john hashcat hydra
)

for p in "${pkgs[@]}"; do
    cand=$(apt-cache policy "$p" 2>/dev/null | grep 'Candidate:' | awk '{print $2}')
    if [ "$cand" = "(none)" ] || [ -z "$cand" ]; then
        echo "MISSING CANDIDATE: $p"
    fi
done
echo "All packages verified successfully!"
