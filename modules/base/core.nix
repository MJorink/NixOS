{ self, ... }: {
  flake.nixosModules.base =
    {
      lib,
      pkgs,
      ...
    }:
    {
      # Use wrapped shell
      users.defaultUserShell = self.packages.${pkgs.stdenv.hostPlatform.system}.myShell;
      environment.shells = [ "${self.packages.${pkgs.stdenv.hostPlatform.system}.myShell}/bin/fish" ];

      # Make runtimePkgs from wrapped shell available to other programs
      environment.systemPackages = map (
        entry: entry.data
      ) self.packages.${pkgs.stdenv.hostPlatform.system}.myShell.configuration.runtimePkgs;

      # Networking
      networking.networkmanager.enable = true;
      preservation.preserveAt."/persistent" = {
        directories = [
          "/etc/NetworkManager/"
        ];
      };

      # Fixes scripts that use /bin/bash
      systemd.tmpfiles.rules = [
        "L+ /bin/bash - - - - ${pkgs.bash}/bin/bash"
      ];

      # Fixes dynamic binary issues
      programs.nix-ld.enable = true;

      # Basics
      security.sudo.wheelNeedsPassword = false;
      time.timeZone = "Europe/Amsterdam";
      boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      nixpkgs.config.allowUnfree = true;
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Don't change
      system.stateVersion = "26.05";
    };
}
