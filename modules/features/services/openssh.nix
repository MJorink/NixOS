{ ... }: {
  flake.nixosModules.openssh = { ... }: {
    services.openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AuthenticationMethods = "password";
      };
    };

    # Only allow SSH from the home LAN
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp --dport 22 -s 192.168.100.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p tcp --dport 22 -j nixos-fw-refuse
    '';
  };
}
