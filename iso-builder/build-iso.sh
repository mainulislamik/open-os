#!/usr/bin/env bash
# ==============================================================================
# Open OS - Host ISO Builder Trigger
# Uses Docker to cleanly build the Kali-based ISO without host contamination
# Usage: ./build-iso.sh
# ==============================================================================

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="$REPO_ROOT/iso-builder/output"

mkdir -p "$OUTPUT_DIR"

COLOR_CYAN="\033[1;36m"
COLOR_GREEN="\033[1;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_RESET="\033[0m"

echo -e "${COLOR_CYAN}"
echo "=============================================================="
echo "           Open OS - Dockerized Kali ISO Builder              "
echo "=============================================================="
echo -e "${COLOR_RESET}"

if ! command -v docker >/dev/null 2>&1; then
    echo "[!] Docker is required to build the ISO safely."
    exit 1
fi

echo -e "${COLOR_YELLOW}[1/3] Building Open OS ISO builder Docker container...${COLOR_RESET}"
docker build -t open-os-iso-builder -f "$REPO_ROOT/iso-builder/Dockerfile" "$REPO_ROOT/iso-builder"

echo -e "${COLOR_YELLOW}[2/3] Running Kali Live-Build inside isolated privileged container...${COLOR_RESET}"
docker run --rm --privileged \
    -v "$REPO_ROOT/config:/build/config:ro" \
    -v "$REPO_ROOT/core:/build/core:ro" \
    -v "$REPO_ROOT/iso-builder/builder-entrypoint.sh:/build/builder-entrypoint.sh:ro" \
    -v "$OUTPUT_DIR:/build/output" \
    open-os-iso-builder

echo -e "${COLOR_GREEN}[3/3] Done! Check output directory: $OUTPUT_DIR${COLOR_RESET}"
