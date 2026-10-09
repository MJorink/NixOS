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
          # NixNuc lives on its own VLAN, still treat it (and the home LAN) as local
          alwaysLocalNets = [
            "192.168.100.0/24"
            "192.168.10.0/24"
          ];
        };
        devices.victus = {
          id = "RB5HBV7-H5WJGZR-HWWVEWL-IMYWQWV-LR5M6DE-SGPTT7T-MJH4TOD-DE7L5QR";
          addresses = [ "dynamic" ];
        };
        devices.nixpad = {
          id = "IYAEDFY-TCF3NRB-TWSJNOR-CGPH3FX-THK5DCI-RU4B22L-UIINIWE-36CCTQP";
          addresses = [ "dynamic" ];
        };
        devices.nixnuc = {
          id = "TFOQX2M-J6RNRVE-PZAHUXB-KI7SJ7O-63WI4S4-YJMTUXD-MMPMBWY-EQBHOQC";
          addresses = [ "tcp://192.168.10.20:22000" ];
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

    # Only allow syncthing sync/discovery from the home LAN and NixNuc's VLAN
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp --dport 22000 -s 192.168.100.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --dport 22000 -s 192.168.100.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --dport 21027 -s 192.168.100.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p tcp --dport 22000 -s 192.168.10.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --dport 22000 -s 192.168.10.0/24 -j nixos-fw-accept
    '';

    preservation.preserveAt."/persistent" = {
      users.jorink.directories = [
        ".config/syncthing"
      ];
    };
  };
}
