# NixOS

NixOS for a ThinkPad X270: the dwl desktop from `alpine-setup`, on a tmpfs root.

## Install

From the NixOS minimal ISO:

```sh
iwctl                      # station wlan0 connect <SSID>
git clone https://github.com/MJorink/NixOS && cd NixOS
sudo ./install.sh          # erases /dev/nvme0n1; asks: YES, user password, disk passphrase
reboot
```

## Design

| Part | Choice | Why |
|---|---|---|
| Root | **tmpfs** `/`, `/nix` + `/persist` on btrfs | Wiped by a reboot with no rollback script; only `environment.persistence` paths survive. |
| Disk | GPT, ESP, **LUKS2 → btrfs** (zstd, noatime) | zstd roughly halves `/nix`; no ZFS module/ARC (less RAM, no kernel pinning). |
| Boot | systemd-boot (no menu: hold Space), systemd initrd | Fastest path to the LUKS prompt. |
| Network | **iwd** alone (DHCP built in), resolvconf | No NetworkManager/dhcpcd/resolved. |
| Session | logind + dwl from `~/.profile` on tty1 | No display manager, no seatd, no polkit; doas rules for suspend/reboot/poweroff. |
| Logs | journald in RAM (32M) | No disk writes. |
| Swap | zram 25% | |
| Firmware | X270 subset only | Not the whole linux-firmware. |
| Docker, sshd | socket-activated | Nothing runs until first use. |

Packages and patches: [MJorink/packages](https://github.com/MJorink/packages).
Dotfiles: [MJorink/dotfiles](https://github.com/MJorink/dotfiles). See `CLAUDE.md` for the rules.

Persisted: `~/repos`, `~/Downloads`, `~/Documents`, `~/.ssh`, `~/.local/state`,
`~/.local/share/nvim`, `~/.config/librewolf`, `~/.claude`, `~/.nuget`, and `/var/lib/{nixos,iwd,bluetooth,docker,systemd/timers}`, `/etc/machine-id`.
