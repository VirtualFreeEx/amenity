# x86_64-v2 support.
ARG BASE_IMAGE_TAG="latest"

# Set up files that will be stored in the image's rootfs.
FROM scratch AS files
COPY system_files /
COPY cosign.pub /usr/lib/pki/containers/amenity.pub

# Main image.
FROM quay.io/almalinuxorg/almalinux-bootc:${BASE_IMAGE_TAG}

# Remove `rhc` and `subscription-manager`.
RUN dnf remove rhc subscription-manager --assumeyes

# Setup EPEL.
RUN dnf install epel-release --assumeyes && crb enable

# Firewalld.
RUN dnf install firewalld --assumeyes

# USBGuard.
RUN dnf install usbguard --assumeyes

# Install fail2ban, fix configuration.
RUN dnf install fail2ban-all --assumeyes && \
    sed 's/^dbfile.*/dbfile = :memory:/' -i /etc/fail2ban/fail2ban.conf

# systemd-resolved.
RUN dnf install systemd-resolved --assumeyes

# zram-generator.
RUN dnf install zram-generator --assumeyes

# Podman compose.
RUN dnf install podman-compose --assumeyes

# Docker.
RUN dnf config-manager \
    --add-repo=https://download.docker.com/linux/rhel/docker-ce.repo && \
    dnf install docker-ce --assumeyes

# Restore files that are supposed to be here.
RUN --mount=type=bind,from=files,source=/,dst=/files cp /files/* / -avfr

# Regenerate the initramfs.
# Credits: Taxifolia
RUN KERNEL_VERSION="$(find "/usr/lib/modules" -maxdepth 1 -type d ! -path "/usr/lib/modules" -exec basename '{}' ';' | sort | tail --lines 1)" && \ 
    export DRACUT_NO_XATTR=1 && \
    dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible --zstd --verbose --add ostree --force "/usr/lib/modules/$KERNEL_VERSION/initramfs.img" && \
    chmod 0600 "/usr/lib/modules/${KERNEL_VERSION}/initramfs.img"

# Finalise.
RUN rm -rf /var/* && bootc container lint --fatal-warnings
