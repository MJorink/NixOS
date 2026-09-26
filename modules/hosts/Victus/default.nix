{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.Victus = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.VictusModule ];
  };

  flake.nixosModules.VictusModule =
    {
      lib,
      pkgs,
      ...
    }:
    {
      networking.hostName = "Victus";
      imports = [
        self.nixosModules.base
        self.nixosModules.jorink
        self.nixosModules.desktop
        self.nixosModules.auto-cpufreq
        self.nixosModules.mullvad-vpn
        self.nixosModules.browser
        self.nixosModules.claude
        self.nixosModules.media
        self.nixosModules.minecraft
        self.nixosModules.office
        self.nixosModules.recording
        self.nixosModules.security
        self.nixosModules.socials
        self.nixosModules.steam
      ];

      # Windows 10 boot option
      boot.loader.systemd-boot.edk2-uefi-shell.enable = true;
      boot.loader.systemd-boot.windows."10" = {
        title = "Windows 10";
        efiDeviceHandle = "HD0b";
      };
    };
}
