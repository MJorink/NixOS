{ self, inputs, ... }: {
  flake.nixosConfigurations.Victus = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.VictusModule ];
  };

  flake.nixosModules.VictusModule = { config, lib, pkgs, ... }: {
    networking.hostName = "Victus";

    imports = [
      self.nixosModules.base
      self.nixosModules.jorink
      self.nixosModules.desktop
      self.nixosModules.tlp
      self.nixosModules.mullvad-vpn
      self.nixosModules.browser
      self.nixosModules.claude
      self.nixosModules.media
      self.nixosModules.minecraft
      self.nixosModules.office
      self.nixosModules.recording
      self.nixosModules.security
      self.nixosModules.socials
      self.nixosModules.syncthing
      self.nixosModules.steam
    ];

    # Windows 10 boot option, listed first and booted by default
    boot.loader.systemd-boot.windows."10" = {
      title = "Windows 10";
      efiDeviceHandle = "HD0b";
      sortKey = "a_windows_10";
    };
    boot.loader.systemd-boot.extraInstallCommands = ''
      ${pkgs.gnused}/bin/sed -i 's/^default .*/default windows_10.conf/' ${config.boot.loader.efi.efiSysMountPoint}/loader/loader.conf
    '';
  };
}
