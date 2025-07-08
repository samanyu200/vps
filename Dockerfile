FROM ubuntu:22.04

# Set environment
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

# Enable root login for Cockpit
RUN mkdir -p /etc/systemd/system/getty@tty1.service.d && \
    echo "[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin root --noclear %I $TERM" > /etc/systemd/system/getty@tty1.service.d/override.conf

# Enable services
RUN systemctl enable cockpit.socket
RUN systemctl enable libvirtd.service

# Expose Cockpit web UI port
EXPOSE 9090

# Start systemd
CMD ["/sbin/init"]
