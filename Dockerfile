FROM ubuntu:22.04

ENV container docker

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    cockpit \
    cockpit-machines \
    cockpit-networkmanager \
    cockpit-storaged \
    cockpit-packagekit \
    sudo \
    libvirt-clients \
    libvirt-daemon-system \
    qemu-kvm \
    && apt-get clean

RUN echo "root:root" | chpasswd

# Expose Cockpit on port 8080
EXPOSE 8080

# Start Cockpit Web Service manually (no systemd)
CMD ["bash", "-c", "cockpit-ws --no-tls --port 8080 --for-tls-proxy --local-ssh"]
