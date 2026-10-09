{ ... }: {
  flake.nixosModules.media = { lib, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      mpv
      supersonic
    ];

    preservation.preserveAt."/persistent" = {
      users.jorink.directories = [
        ".config/supersonic"
      ];
    };
  };
}
