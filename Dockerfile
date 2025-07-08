FROM ubuntu:22.04

# Set environment for systemd
ENV container docker

# Install Cockpit and virtualization tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
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

# Set root password
RUN echo "root:root" | chpasswd

# Change Cockpit port to 8080
RUN mkdir -p /etc/systemd/system/cockpit.socket.d && \
    echo -e "[Socket]\nListenStream=\nListenStream=8080" > /etc/systemd/system/cockpit.socket.d/listen.conf

# Enable Cockpit and libvirt services
RUN systemctl enable cockpit.socket && \
    systemctl enable libvirtd.service

# Expose Cockpit web UI on port 8080
EXPOSE 8080

# Start systemd
CMD ["/sbin/init"]
