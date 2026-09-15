{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    preservation.url = "github:nix-community/preservation";
    disko.url = "github:nix-community/disko";

    mangowm.url = "github:mangowm/mango";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    nvf.url = "github:notashelf/nvf";
  };
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        (inputs.import-tree ./modules)
        (inputs.import-tree ./wrapped)
      ];
    };
}
