#!/usr/bin/env bash
# Fresh install from the NixOS minimal ISO. Before running this: boot the ISO,
# connect to the internet (iwctl), git clone https://github.com/MJorink/NixOS, cd NixOS.
#   sudo ./install.sh
# ERASES the disk set in modules/system/disk.nix (/dev/nvme0n1).
set -euo pipefail

host=thinkpad
user=jorink
nix=(nix --extra-experimental-features "nix-command flakes")

[ "$(id -u)" -eq 0 ] || exec sudo "$0" "$@"
cd "$(dirname "$0")"

read -rp "This ERASES /dev/nvme0n1 (see modules/system/disk.nix). Type YES to continue: " ok
[ "$ok" = YES ] || { echo "Aborted."; exit 1; }

# User password, asked first so the rest runs unattended (disko asks the LUKS passphrase)
while :; do
	read -rsp "Password for $user: " pw; echo
	read -rsp "Again: " pw2; echo
	[ -n "$pw" ] && [ "$pw" = "$pw2" ] && break
	echo "Empty or not the same, try again."
done
hash=$(printf '%s' "$pw" | "${nix[@]}" run nixpkgs#mkpasswd -- -m sha-512 -s)
unset pw pw2

echo "==> Partitioning, encrypting and mounting (asks for the disk passphrase)"
"${nix[@]}" run github:nix-community/disko/latest -- \
	--mode destroy,format,mount --yes-wipe-all-disks --flake ".#$host"

echo "==> Persistent state"
install -d -m 0700 /mnt/persist/passwords
printf '%s\n' "$hash" > "/mnt/persist/passwords/$user"
chmod 0600 "/mnt/persist/passwords/$user"
install -d -m 0755 /mnt/persist/etc/ssh

home=/mnt/persist/home/$user
install -d "$home/repos" "$home/Downloads" "$home/Documents" "$home/.local/state"
cp -a . "$home/repos/NixOS"
for repo in dotfiles packages; do
	git clone "https://github.com/MJorink/$repo" "$home/repos/$repo"
done
chown -R 1000:100 "$home" # uid of $user (users.nix), group users

echo "==> Installing"
nixos-install --flake ".#$host" --no-root-passwd --no-channel-copy

echo "Done. Reboot, log in on tty1 and dwl starts."
