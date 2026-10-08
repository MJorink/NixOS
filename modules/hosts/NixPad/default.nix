{ self, inputs, ... }: {
  flake.nixosConfigurations.NixPad = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.NixPadModule ];
  };

  flake.nixosModules.NixPadModule = { lib, pkgs, ... }: {
    networking.hostName = "NixPad";

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
      self.nixosModules.syncthing
    ];

    # Sync repos to the Windows VM on NixNuc (its syncthing is forwarded on nixnuc:22001)
    services.syncthing.settings = {
      devices.windows = {
        id = "MU4V2FX-HD2ZG2E-64AXAVC-DX7XVMD-F7RFNDJ-SPVRT3T-U4FTXYZ-W6R5EAT";
        addresses = [ "tcp://nixnuc:22001" ];
      };
      folders."repos" = {
        path = "/home/jorink/repos";
        devices = [ "windows" ];
        ignorePatterns = [ ".git" ];
      };
    };
  };
}
