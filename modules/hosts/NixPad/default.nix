{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.NixPad = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.NixPadModule];
  };

  flake.nixosModules.NixPadModule = {
    lib,
    pkgs,
    ...
  }: {
    networking.hostName = "NixPad";
    imports = [
      self.nixosModules.base
      self.nixosModules.jorink
      self.nixosModules.desktop
      self.nixosModules.browser
      self.nixosModules.claude
      self.nixosModules.media
      self.nixosModules.neovim
      self.nixosModules.office
      self.nixosModules.security
      self.nixosModules.socials
      self.nixosModules.auto-cpufreq
      self.nixosModules.docker
      self.nixosModules.mullvad-vpn
    ];
  };
}
