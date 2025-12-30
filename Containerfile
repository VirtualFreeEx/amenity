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

# Disable USB.
# Snipet credits: VedaOS
RUN echo 'kargs = ["usbcore.nousb", "usbcore.authorized_default=0"]' >> /usr/lib/bootc/kargs.d/00-usb.toml

# Lockdown.
# Snipet credits: VedaOS
RUN echo 'kargs = ["lockdown=confidentiality"]' >> /usr/lib/bootc/kargs.d/00-lockdown.toml

# Fail2ban.
RUN dnf install fail2ban --assumeyes

# dnscrypt-proxy.
RUN dnf install dnscrypt-proxy --assumeyes

# zram-generator.
RUN dnf install zram-generator --assumeyes && \
    echo -e "[zram0]\n\
zram-size = min(ram, 8192)" > /usr/lib/systemd/zram-generator.conf

# Regenerate the initramfs.
# Credits: Taxifolia
RUN KERNEL_VERSION="$(find "/usr/lib/modules" -maxdepth 1 -type d ! -path "/usr/lib/modules" -exec basename '{}' ';' | sort | tail -n 1)" && \ 
    export DRACUT_NO_XATTR=1 && \
    dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible --zstd --verbose --add ostree --force "/usr/lib/modules/$KERNEL_VERSION/initramfs.img" && \
    chmod 0600 "/usr/lib/modules/${KERNEL_VERSION}/initramfs.img"

    
# Finalise.
RUN rm -rf /var/* && bootc container lint --fatal-warnings
