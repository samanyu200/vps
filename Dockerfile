FROM ubuntu:22.04

# Set environment for systemd
ENV container docker

# Install Cockpit and dependencies
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

# Set root password
RUN echo "root:root" | chpasswd

# Disable Cockpit HTTPS redirect and change to port 8080
RUN mkdir -p /etc/systemd/system/cockpit.socket.d && \
    echo -e "[Socket]\nListenStream=\nListenStream=8080" > /etc/systemd/system/cockpit.socket.d/listen.conf

# Tell Cockpit it’s behind a proxy (fix GitHub.dev redirect loop)
RUN mkdir -p /etc/systemd/system/cockpit.service.d && \
    echo -e "[Service]\nEnvironment=GIO_EXTRA_MODULES=/usr/lib/x86_64-linux-gnu/gio/modules\nExecStart=\nExecStart=/usr/lib/cockpit/cockpit-ws --no-tls --for-tls-proxy" > /etc/systemd/system/cockpit.service.d/override.conf

# Enable Cockpit and libvirtd services
RUN systemctl enable cockpit.socket
RUN systemctl enable libvirtd.service

# Expose Cockpit web UI on 8080
EXPOSE 8080

# Start systemd
CMD ["/sbin/init"]
