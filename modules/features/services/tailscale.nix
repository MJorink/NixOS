{ ... }: {
  flake.nixosModules.tailscale = { pkgs, ... }: {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--operator=jorink" ];
    };

    preservation.preserveAt."/persistent".directories = [
      "/var/lib/tailscale"
    ];

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

    # Add a desktop entry for Victus RDP
    environment.systemPackages = [
      pkgs.freerdp
      (pkgs.makeDesktopItem {
        name = "victus-rdp";
        desktopName = "Victus (Windows)";
        icon = "preferences-desktop-remote-desktop";
        exec = toString (
          pkgs.writeShellScript "victus-rdp" ''
            ${pkgs.freerdp}/bin/sdl-freerdp /v:victus /u:jorink /p:windows /dynamic-resolution
          ''
        );
      })
    ];

    services.syncthing = {
      enable = true;
      user = "jorink";
      dataDir = "/home/jorink";
      configDir = "/home/jorink/.config/syncthing";
      openDefaultPorts = true;

      settings = {
        devices.victus.id = "VGATET5-RRWQCIT-AADHMV4-443VIKB-QDVRAC4-J4B2DF5-LAH6JCH-T7Z2BAI";
        folders."shared" = {
          path = "/home/jorink/repos";
          devices = [ "victus" ];
        };
      };
    };
  };
}
