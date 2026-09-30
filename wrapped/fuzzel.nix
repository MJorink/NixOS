{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.myFuzzel = inputs.wrapper-modules.wrappers.fuzzel.wrap {
      inherit pkgs;
      settings = {
        main = {
          font = "MesloLGS Nerd Font:size=12";
          terminal = "foot";
          icons-enabled = false;
          lines = 10;
          width = 40;
        };
        colors = {
          background = "282828ff";
          text = "ebdbb2ff";
          prompt = "d65d0eff";
          input = "ebdbb2ff";
          match = "d65d0eff";
          selection = "3c3836ff";
          selection-text = "ebdbb2ff";
          selection-match = "fe8019ff";
          border = "d65d0eff";
        };
        border = {
          width = 2;
          radius = 0;
        };
      };
    };
  };
}
