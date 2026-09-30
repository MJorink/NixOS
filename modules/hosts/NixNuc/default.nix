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

    # Remote access goes through tailscale (run `sudo tailscale up` once over LAN ssh)
    services.tailscale = {
      enable = true;
      openFirewall = true; # UDP 41641 for direct connections instead of DERP relay
    };
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

    # Keep logs across reboots, root is tmpfs
    preservation.preserveAt."/persistent".directories = [
      "/var/lib/tailscale"
      "/var/log"
    ];

    # Small disk, clean up old generations
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    nix.optimise.automatic = true;
  };
}
