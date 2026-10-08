{ ... }: {
  flake.nixosModules.media = { lib, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      spotify
      mpv
      supersonic
    ];

    preservation.preserveAt."/persistent" = {
      users.jorink.directories = [
        ".config/spotify"
        ".cache/spotify"
      ];
    };
  };
}
