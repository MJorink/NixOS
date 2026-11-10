# disko layout: ESP + LUKS2 -> btrfs (zstd) with /nix and /persist. / is tmpfs.
# install.sh formats with this. Change `device` if the disk is not nvme0n1.
{ inputs, ... }:
{
  flake.modules.nixos.disk = {
    imports = [ inputs.disko.nixosModules.disko ];

    disko.devices = {
      disk.main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            crypt = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt";
                # discards for the SSD; no dm-crypt workqueues (lower latency on NVMe)
                settings = { allowDiscards = true; bypassWorkqueues = true; };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes =
                    let opts = [ "compress=zstd" "noatime" ];
                    in {
                      "/nix" = { mountpoint = "/nix"; mountOptions = opts; };
                      "/persist" = { mountpoint = "/persist"; mountOptions = opts; };
                    };
                };
              };
            };
          };
        };
      };
      # Root in RAM: everything not persisted is gone after a reboot
      nodev."/" = { fsType = "tmpfs"; mountOptions = [ "size=25%" "mode=755" ]; };
    };

    fileSystems."/persist".neededForBoot = true;
  };
}
