{ inputs, ... }: {
  flake.nixosModules.VictusModule =
    { lib, pkgs, ... }:
    {
      imports = [ inputs.disko.nixosModules.disko ];

      fileSystems."/nix".neededForBoot = true;
      fileSystems."/persistent".neededForBoot = true;

      disko.devices.nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [ "size=25%" "mode=755" ];
      };

      disko.devices.disk.esp = {
        type = "disk";
        device = "/dev/disk/by-partlabel/NIXBOOT";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };

      disko.devices.disk.swap = {
        type = "disk";
        device = "/dev/disk/by-partlabel/NIXSWAP";
        content = {
          type = "swap";
          resumeDevice = true;
        };
      };

      disko.devices.disk.root = {
        type = "disk";
        device = "/dev/disk/by-partlabel/NIXROOT";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
            "/persistent" = {
              mountOptions = [ "subvol=persistent" "noatime" ];
              mountpoint = "/persistent";
            };
            "/nix" = {
              mountOptions = [ "subvol=nix" "noatime" ];
              mountpoint = "/nix";
            };
          };
        };
      };
    };
}
