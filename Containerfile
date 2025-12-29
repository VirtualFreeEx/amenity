FROM quay.io/centos-bootc/centos-bootc:stream10

# Firewalld.
RUN dnf install firewalld --assumeyes

# USBGuard.
RUN dnf install usbguard --assumeyes && \
    systemctl enable usbguard

# Disable USB.
# Snipet credits: VedaOS
RUN echo 'kargs = ["usbcore.nousb", "usbcore.authorized_default=0"]' >> /usr/lib/bootc/kargs.d/00-usb.toml

# Regenerate the initramfs.
# Credits: Taxifolia
RUN <<EOF
KERNEL_VERSION="$(find "/usr/lib/modules" -maxdepth 1 -type d ! -path "/usr/lib/modules" -exec basename '{}' ';' | sort | tail -n 1)"
export DRACUT_NO_XATTR=1
dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible --zstd --verbose --add ostree --force "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"
chmod 0600 "/usr/lib/modules/${KERNEL_VERSION}/initramfs.img"
EOF
    
# Finalise.
RUN rm -rf /var/* && bootc container lint --fatal-warnings
