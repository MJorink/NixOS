{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.desktop =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        inputs.mangowm.nixosModules.mango
      ];

      programs.mango = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myMango;
      };

      # Make runtimePkgs from myMango available system-wide
      environment.systemPackages = map (
        entry: entry.data
      ) self.packages.${pkgs.stdenv.hostPlatform.system}.myMango.configuration.runtimePkgs;

      # For hot-reloading
      systemd.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.myMango ];

      # Only enable mullvad-vpn gui if normal service is enabled
      services.mullvad-vpn.gui.enable = config.services.mullvad-vpn.enable;

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
        config.common.defualt = "*";
      };

      fonts.packages = with pkgs; [
        nerd-fonts.meslo-lg
      ];

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".local/state/wireplumber"
          ".local/state/noctalia"
          ".local/share/keyrings"
          "Downloads"
          "Documents"
        ];
      };
    };
}
