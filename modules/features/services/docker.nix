{ ... }: {
  flake.nixosModules.docker = { lib, pkgs, ... }: {
    users.users.jorink.extraGroups = [
      "docker"
    ];

    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };
}
