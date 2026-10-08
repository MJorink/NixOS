{ self, inputs, ... }: {
  flake.nixosConfigurations.NixNuc = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.NixNucModule ];
  };

  flake.nixosModules.NixNucModule = { lib, pkgs, ... }: {
    networking.hostName = "NixNuc";

    # Static IP on its own VLAN, matches any wired interface
    networking.networkmanager.ensureProfiles.profiles.lan = {
      connection = {
        id = "lan";
        type = "ethernet";
        autoconnect = true;
      };
      ipv4 = {
        method = "manual";
        address1 = "192.168.10.20/24,192.168.10.1";
        dns = "192.168.10.1;";
      };
      ipv6.method = "disabled";
    };

    imports = [
      self.nixosModules.base
      self.nixosModules.jorink
      self.nixosModules.mullvad-vpn
      self.nixosModules.openssh
      self.nixosModules.syncthing
      self.nixosModules.windows-vm
      self.nixosModules.music
    ];

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    nix.optimise.automatic = true;
  };
}
