{ ... }: {
  flake.nixosModules.base = { lib, pkgs, ... }: {
    environment.variables = {
      EDITOR = "nvim";
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
