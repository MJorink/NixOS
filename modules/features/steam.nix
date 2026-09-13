{ ... }: {
  flake.nixosModules.steam = { lib, pkgs, ... }: {
    programs.steam.enable = true;
    environment.systemPackages = with pkgs; [ protonup-qt ];

    preservation.preserveAt."/persistent" = {
      users.jorink.directories = [
        ".local/share/Steam"
        ".steam"
      ];
    };
  };
}
