{ self, inputs, ... }: {
  flake.nixosConfigurations.NixNuc = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.NixNucModule ];
  };

  flake.nixosModules.NixNucModule = { lib, pkgs, ... }: {
    networking.hostName = "NixNuc";

    imports = [
      self.nixosModules.base
      self.nixosModules.jorink
      self.nixosModules.mullvad-vpn
      self.nixosModules.openssh
      self.nixosModules.tailscale
      self.nixosModules.syncthing
      self.nixosModules.windows-vm
    ];

    preservation.preserveAt."/persistent".directories = [
      "/var/log"
    ];

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    nix.optimise.automatic = true;
  };
}
