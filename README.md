# Amenity
An image shipping some bullshit that `centos-bootc` maintainers feel like
is unimportant out of the box.

Mostly contains modifications related to hardening the base system.

> [!IMPORTANT]
> This image is intended as a personal image for my VPS(es). Usage on your
> own computers is EXTREMELY discouraged due to changes in this image being
> unsuitable for most computers.
> 
> Nobody, however, prohibits you from doing so. Just remember this:
> use at your own risk!

## Changes
- `firewalld` is now present and enabled on the base system.
- `usbguard` is present and
(un)configured out of the box to not allow any USB devices.
- Just in case, USB is unauthorized *and* disabled at boot-time via a
set of kernel parameters (`usbcore.nousb usbcore.authorized_default = 0`)
- `fail2ban` is now present on the base system, however there is no
configuration by default.
- The `lockdown` LSM is enabled in `confidentiality` mode.
- `dnscrypt-proxy` is now present on the base system.
