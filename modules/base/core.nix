{ self, inputs, ... }: {
  flake.nixosModules.base = { lib, pkgs, ... }: {
    security.sudo.wheelNeedsPassword = false;
    users.defaultUserShell = self.packages.${pkgs.stdenv.hostPlatform.system}.myShell;
    environment.shells = [ "${self.packages.${pkgs.stdenv.hostPlatform.system}.myShell}/bin/fish" ];
    environment.systemPackages = map (
      entry: entry.data
    ) self.packages.${pkgs.stdenv.hostPlatform.system}.myShell.configuration.runtimePkgs;

    time.timeZone = "Europe/Amsterdam";
    networking.networkmanager.enable = true;

    preservation.preserveAt."/persistent" = {
      directories = [
        "/etc/NetworkManager/"
      ];
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Fixes scripts that need /bin/bash to exist
    systemd.tmpfiles.rules = [
      "L+ /bin/bash - - - - ${pkgs.bash}/bin/bash"
    ];

    # Fixes dynamic binaries issues
    programs.nix-ld.enable = true;

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    system.stateVersion = "26.05";
  };
}
