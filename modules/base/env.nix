{ ... }: {
  flake.nixosModules.base =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.variables = {
        EDITOR = "nvim";
        DOTNET_ROOT = "${pkgs.dotnet-sdk_10}/share/dotnet";
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".local/share/direnv"
        ];
      };
    };
}
