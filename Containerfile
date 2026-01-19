# Set up files that will be stored in the image's rootfs.
FROM scratch AS files
COPY system_files /

# Main image.
FROM quay.io/centos-bootc/centos-bootc:stream10

# Setup EPEL.
RUN dnf in epel-release --assumeyes && crb enable

# Post-quantum cryptography policies.
RUN dnf install crypto-policies-pq-preview crypto-policies-scripts && \
    update-crypto-policies --set DEFAULT:TEST-PQ

# Firewalld.
RUN dnf install firewalld --assumeyes

# USBGuard.
RUN dnf install usbguard --assumeyes

# Fail2ban.
RUN dnf install fail2ban --assumeyes

# dnscrypt-proxy.
RUN dnf install dnscrypt-proxy --assumeyes

# zram-generator.
RUN dnf install zram-generator --assumeyes

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
