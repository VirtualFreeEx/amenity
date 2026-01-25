# Amenity ![Trans Rights badge](https://img.shields.io/badge/trans%20rights-grey?logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB2aWV3Qm94PSIwIDAgMzYgMjYiIHdpZHRoPSIzNiIgaGVpZ2h0PSIyNiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBjbGlwLXBhdGg9InVybCgjYSkiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDAgLTUpIj48cGF0aCBmaWxsPSIjNWJjZWZhIiBkPSJNMCA1aDM2djUuM0gweiIvPjxwYXRoIGZpbGw9IiNmNWE5YjgiIGQ9Ik0wIDEwLjJoMzZ2NS4zSDB6Ii8%2BPHBhdGggZmlsbD0iI2ZmZiIgZD0iTTAgMTUuNGgzNnY1LjNIMHoiLz48cGF0aCBmaWxsPSIjZjVhOWI4IiBkPSJNMCAyMC42aDM2djUuM0gweiIvPjxwYXRoIGZpbGw9IiM1YmNlZmEiIGQ9Ik0wIDI1LjhoMzZ2NS4zSDB6Ii8%2BPC9nPjxkZWZzPjxjbGlwUGF0aCBpZD0iYSI%2BPHBhdGggZmlsbD0iI2VlZSIgZD0iTTM2IDI3YTQgNCAwIDAgMS00IDRINGE0IDQgMCAwIDEtNC00VjlhNCA0IDAgMCAxIDQtNGgyOGE0IDQgMCAwIDEgNCA0eiIvPjwvY2xpcFBhdGg%2BPC9kZWZzPjwvc3ZnPg%3D%3D)

An image shipping some bullshit that the upstream image maintainers feel like
is unimportant out of the box.

Mostly contains modifications related to hardening the base system.

> [!IMPORTANT]
> This image is intended as a personal image for my VPS(es). Usage on your
> own computers is EXTREMELY discouraged due to changes in this image being
> unsuitable for most computers.
> 
> Nobody, however, prohibits you from doing so. Just remember this:
> use at your own risk!

## Credits

There are snippets and bits of structure used from the following projects:
- [Taxifolia](https://github.com/tulilirockz/taxifolia), and
- [Carinata](https://github.com/tulilirockz/carinata) by Alice;
- [VedaOS](https://github.com/Lumaeris/vedaos) by Jill.

I want to credit Taxifolia especially, as the base project structure,
as well as CI configuration are taken directly from there.

See the [credits](./CREDITS.md) file for more information.

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
- The system now runs under the post-quantum cryptography policy.
- `zram-generator` is now present on the base system.
- `rhc` and `subscription-manager` are now uninstalled.
- The system checks for image signatures.
- `umask` is now set to `077` by default.
- No shell history file is set by default.
- Root login is now disabled.
- Both the key AND the password are necessary to SSH into the system.
- Kernel is hardened via the command line parameters and some `sysctl`s.

    I am unable to provide the sources for all options, however I tried not to
    enable configurations that are worsening the usability a lot.

