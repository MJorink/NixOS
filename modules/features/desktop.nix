{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.desktop = {
    lib,
    pkgs,
    config,
    ...
  }: {
    imports = [
      inputs.mangowm.nixosModules.mango
      inputs.noctalia.nixosModules.default
    ];

    # Conflicts with flake
    disabledModules = ["programs/wayland/noctalia.nix"];

    # Only enable mullvad-vpn gui if normal service is enabled
    services.mullvad-vpn.gui.enable = config.services.mullvad-vpn.enable;

    services.displayManager.ly.enable = true;
    services.pipewire.enable = true;
    services.pipewire.pulse.enable = true;
    services.upower.enable = true;
    services.gnome.gnome-keyring.enable = true;

    programs.mango = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myMango;
    };

    # For hot-reloading
    systemd.packages = [self.packages.${pkgs.stdenv.hostPlatform.system}.myMango];

    # Screen sharing/recording support
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      wlr.settings.screencast.chooser_type = "none";
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
      config.common.defualt = "*";
    };

    # Use noctalia from cachix instead of building it
    nix.settings = {
      extra-substituters = ["https://noctalia.cachix.org"];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    programs.noctalia = {
      enable = true;
      recommendedServices.enable = false;
      # package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia;
    };

    environment.systemPackages = with pkgs; [bibata-cursors];
    fonts.packages = with pkgs; [nerd-fonts.meslo-lg];

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
