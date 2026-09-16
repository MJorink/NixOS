{ ... }: {
  flake.nixosModules.openssh =
    { ... }:
    {
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = true;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AuthenticationMethods = "publickey,password";
        };
      };

      # Only allow SSH from the home LAN
      networking.firewall.extraCommands = ''
        iptables -A nixos-fw -p tcp --dport 22 -s 192.168.100.0/24 -j nixos-fw-accept
        iptables -A nixos-fw -p tcp --dport 22 -j nixos-fw-refuse
      '';

      users.users.jorink.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGl5L3w+pAB0VcCfAK8SrdDv3Bqs/P0aV4gfoayEjQYg jorink@Victus"
      ];
    };
}
