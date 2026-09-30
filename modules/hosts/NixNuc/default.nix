{ self, inputs, ... }: {
  flake.nixosConfigurations.NixNuc = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.NixNucModule ];
  };

  flake.nixosModules.NixNucModule = { lib, pkgs, ... }: {
    networking.hostName = "NixNuc";

    imports = [
      self.nixosModules.base
      self.nixosModules.jorink
      self.nixosModules.openssh
    ];

    services.tailscale = {
      enable = true;
      openFirewall = true;
    };
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

    preservation.preserveAt."/persistent".directories = [
      "/var/lib/tailscale"
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
