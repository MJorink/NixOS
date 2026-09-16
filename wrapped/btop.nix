{ inputs, ... }: {
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    {
      packages.myBtop = inputs.wrapper-modules.wrappers.btop.wrap {
        inherit pkgs;
        settings.color_theme = "gruvbox_dark";
      };
    };
}
