{ ... }: {
  flake.nixosModules.openssh = { ... }: {
    services.openssh = {
      enable = true;
      # Port 22 is opened by the LAN-only rules below, openFirewall would accept it from anywhere
      openFirewall = false;
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AuthenticationMethods = "publickey,password";
      };
      # Root is tmpfs, keep host keys on persistent storage so they survive reboots
      hostKeys = [
        {
          path = "/persistent/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "/persistent/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
    };

    # Only allow SSH from the home LAN
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp --dport 22 -s 192.168.100.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p tcp --dport 22 -j nixos-fw-refuse
    '';

    users.users.jorink.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJm3W8FC3P/KL1QLEZnLf4ut5UmOSntIFbkpkgQyhqRc jorink@Victus"
    ];
  };
}
