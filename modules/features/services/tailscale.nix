{ ... }: {
  flake.nixosModules.tailscale = { pkgs, ... }: {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--operator=jorink" ];
    };

    preservation.preserveAt."/persistent".directories = [
      "/var/lib/tailscale"
    ];

    # Add a desktop entry for Victus RDP
    environment.systemPackages = [
      pkgs.freerdp
      (pkgs.makeDesktopItem {
        name = "victus-rdp";
        desktopName = "Victus (Windows)";
        icon = "preferences-desktop-remote-desktop";
        exec = toString (
          pkgs.writeShellScript "victus-rdp" ''
            ${pkgs.tailscale}/bin/tailscale up
            ${pkgs.freerdp}/bin/sdl-freerdp /v:victus /u:jorink /p:windows /dynamic-resolution
            ${pkgs.tailscale}/bin/tailscale down
          ''
        );
      })
    ];
  };
}
