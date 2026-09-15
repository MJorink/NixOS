{ ... }: {
  flake.nixosModules.media =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        spotify
        mpv
      ];

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".config/spotify"
          ".cache/spotify"
        ];
      };
    };
}
