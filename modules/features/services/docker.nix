{...}: {
  flake.nixosModules.docker = {
    lib,
    pkgs,
    ...
  }: {
    users.users.jorink.extraGroups = [
      "docker"
    ];

    preservation.preserveAt."/persistent" = {
      users.jorink.directories = [
        "docker"
      ];
    };

    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
      daemon.settings = {
        data-root = "/home/jorink/docker";
      };
    };
  };
}
