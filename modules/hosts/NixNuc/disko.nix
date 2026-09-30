{ inputs, ... }: {
  flake.nixosModules.NixNucModule = { lib, pkgs, ... }: {
    imports = [ inputs.disko.nixosModules.disko ];

    fileSystems."/nix".neededForBoot = true;
    fileSystems."/persistent".neededForBoot = true;

    disko.devices.nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=25%"
        "mode=755"
      ];
    };

    disko.devices.disk.main = {
      device = "/dev/nvme0n1";
      type = "disk";
      content.type = "gpt";

      content.partitions.esp = {
        name = "ESP";
        size = "1G";
        type = "EF00";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };

      content.partitions.swap = {
        size = "12G";
        content.type = "swap";
      };

      content.partitions.root = {
        name = "root";
        size = "100%";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
            "/persistent" = {
              mountOptions = [
                "subvol=persistent"
                "noatime"
              ];
              mountpoint = "/persistent";
            };
            "/nix" = {
              mountOptions = [
                "subvol=nix"
                "noatime"
              ];
              mountpoint = "/nix";
            };
          };
        };
      };
    };
  };
}
