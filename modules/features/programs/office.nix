{ ... }: {
  flake.nixosModules.office =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        onlyoffice-desktopeditors
        obsidian
      ];

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".local/share/onlyoffice"
          ".config/onlyoffice"
        ];
      };
    };
}
