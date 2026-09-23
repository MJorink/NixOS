{ inputs, ... }: {
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    {
      packages.myNh = inputs.wrapper-modules.wrappers.nh.wrap {
        inherit pkgs;
        flake = "/home/jorink/NixOS";
        searchChannel = "nixos-unstable";
      };
    };
}
