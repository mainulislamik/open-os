FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    qemu-system-x86 \
    qemu-utils \
    ovmf \
    novnc \
    websockify \
    tigervnc-standalone-server \
    procps \
    net-tools \
    socat \
    netpbm \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY start-vm.sh /start-vm.sh
RUN chmod +x /start-vm.sh

EXPOSE 8006 5900

CMD ["/start-vm.sh"]
