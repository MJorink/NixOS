{...}: {
  flake.nixosModules.base = {
    lib,
    pkgs,
    ...
  }: {
    environment.variables = {
      EDITOR = "nvim";
      NH_FLAKE = "/home/jorink/NixOS";
    };
  };
}
