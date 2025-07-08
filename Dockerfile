FROM ubuntu:22.04

# Set environment for systemd inside container
ENV container docker

# Install required packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    cockpit \
    cockpit-machines \
    cockpit-networkmanager \
    cockpit-storaged \
    cockpit-packagekit \
    libvirt-daemon-system \
    libvirt-clients \
    qemu-kvm \
    virt-manager \
    sudo \
    systemd \
    && apt-get clean

# Set root password to "root"
RUN echo "root:root" | chpasswd

# Disable Cockpit HTTPS redirect (use plain HTTP for Codespaces/GitHub.dev)
RUN mkdir -p /etc/systemd/system/cockpit.socket.d && \
    echo -e "[Socket]\nListenStream=\nListenStream=9090" > /etc/systemd/system/cockpit.socket.d/listen.conf

# Enable Cockpit and libvirtd services
RUN systemctl enable cockpit.socket
RUN systemctl enable libvirtd.service

# Expose Cockpit web UI port
EXPOSE 9090

# Start systemd so services stay alive
CMD ["/sbin/init"]
