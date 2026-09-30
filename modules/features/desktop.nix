{ self, inputs, ... }: {
  flake.nixosModules.desktop =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      programs.dwl = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myDwl;
      };

      # Make runtimePkgs from myDwl available system-wide
      environment.systemPackages = map (
        entry: entry.data
      ) self.packages.${pkgs.stdenv.hostPlatform.system}.myDwl.configuration.runtimePkgs;

      security.pam.services.swaylock = { };

      services.displayManager.ly.enable = true;
      services.pipewire.enable = true;
      services.pipewire.pulse.enable = true;
      services.upower.enable = true;
      services.gnome.gnome-keyring.enable = true;

      # Screen sharing/recording support
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        wlr.settings.screencast.chooser_type = "none";
        extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
        config.common.default = "*";
      };

      fonts.packages = with pkgs; [
        nerd-fonts.meslo-lg
      ];

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".local/state/wireplumber"
          ".local/share/keyrings"
          "Downloads"
          "Documents"
        ];
      };
    };
}
