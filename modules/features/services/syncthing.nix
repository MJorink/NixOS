{ ... }: {
  flake.nixosModules.syncthing = { ... }: {
    services.syncthing = {
      enable = true;
      user = "jorink";
      dataDir = "/home/jorink";
      configDir = "/home/jorink/.config/syncthing";
      openDefaultPorts = false;

      settings = {
        options = {
          globalAnnounceEnabled = false;
          relaysEnabled = false;
          natEnabled = false;
          localAnnounceEnabled = true;
          urAccepted = -1;
        };
        devices.victus = {
          id = "RB5HBV7-H5WJGZR-HWWVEWL-IMYWQWV-LR5M6DE-SGPTT7T-MJH4TOD-DE7L5QR";
          addresses = [
            "tcp://victus:22000"
            "dynamic"
          ];
        };
        devices.nixpad = {
          id = "IYAEDFY-TCF3NRB-TWSJNOR-CGPH3FX-THK5DCI-RU4B22L-UIINIWE-36CCTQP";
          addresses = [
            "tcp://nixpad:22000"
            "dynamic"
          ];
        };
        devices.nixnuc = {
          id = "TFOQX2M-J6RNRVE-PZAHUXB-KI7SJ7O-63WI4S4-YJMTUXD-MMPMBWY-EQBHOQC";
          addresses = [
            "tcp://nixnuc:22000"
            "dynamic"
          ];
        };
        folders."NixOS" = {
          path = "/home/jorink/NixOS";
          devices = [
            "victus"
            "nixpad"
            "nixnuc"
          ];
          ignorePatterns = [ ".git" ];
        };
      };
    };

    # Only allow syncthing sync/discovery from the home LAN
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp --dport 22000 -s 192.168.100.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --dport 22000 -s 192.168.100.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --dport 21027 -s 192.168.100.0/24 -j nixos-fw-accept
    '';

    preservation.preserveAt."/persistent" = {
      users.jorink.directories = [
        ".config/syncthing"
      ];
    };
  };
}
