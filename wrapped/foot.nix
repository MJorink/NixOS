{ inputs, ... }: {
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    {
      packages.myFoot = inputs.wrapper-modules.wrappers.foot.wrap {
        inherit pkgs;
        settings.main = {
          font = "MesloLGS Nerd Font:size=12";
          include = "${pkgs.foot.themes}/share/foot/themes/gruvbox-dark";
        };
      };
    };
}
