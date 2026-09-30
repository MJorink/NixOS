{ self, inputs, ... }: {
  flake.nixosConfigurations.NixPad = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.NixPadModule ];
  };

  flake.nixosModules.NixPadModule = { lib, pkgs, ... }: {
    networking.hostName = "NixPad";

    # Skip boot menu, hold Space during boot to show it
    boot.loader.timeout = 0;

    imports = [
      self.nixosModules.base
      self.nixosModules.jorink
      self.nixosModules.mullvad-vpn
      self.nixosModules.desktop
      self.nixosModules.tlp
      self.nixosModules.browser
      self.nixosModules.claude
      self.nixosModules.media
      self.nixosModules.office
      self.nixosModules.security
      self.nixosModules.socials
      self.nixosModules.docker
      self.nixosModules.openssh
      self.nixosModules.tailscale
      self.nixosModules.syncthing
    ];
  };
}
