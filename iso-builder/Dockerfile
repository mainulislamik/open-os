FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install official live-build and tools for Kali ISO generation
RUN apt-get update && apt-get install -y --no-install-recommends \
    live-build \
    kali-defaults \
    cdebootstrap \
    curl \
    git \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-utils \
    dosfstools \
    mtools \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

ENTRYPOINT ["/build/builder-entrypoint.sh"]
