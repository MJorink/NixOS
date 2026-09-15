{ ... }: {
  flake.nixosModules.recording =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        obs-studio
        kdePackages.kdenlive
      ];

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".config/obs-studio"
          ".cache/stalefiles/kdenlive"
          ".local/share/kdenlive"
        ];
      };
    };
}
