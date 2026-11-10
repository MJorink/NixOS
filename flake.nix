{
  description = "NixOS for a ThinkPad X270: dwl, tmpfs root (impermanence), as light as possible";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = { url = "github:hercules-ci/flake-parts"; inputs.nixpkgs-lib.follows = "nixpkgs"; };
    import-tree.url = "github:vic/import-tree";
    disko = { url = "github:nix-community/disko"; inputs.nixpkgs.follows = "nixpkgs"; };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = ""; # only used by its home-manager module
    };
    wrappers = { url = "github:lassulus/wrappers"; inputs.nixpkgs.follows = "nixpkgs"; };
    packages = { url = "github:MJorink/packages"; inputs.nixpkgs.follows = "nixpkgs"; };
    dotfiles = { url = "github:MJorink/dotfiles"; flake = false; };
  };

  # Dendritic: every .nix file under modules/ is a flake-parts module (import-tree).
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
