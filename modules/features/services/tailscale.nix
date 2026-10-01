{ ... }: {
  flake.nixosModules.tailscale =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.tailscale = {
        enable = true;
        openFirewall = true;
        extraSetFlags = [ "--operator=jorink" ];
      };

      preservation.preserveAt."/persistent".directories = [
        "/var/lib/tailscale"
      ];

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

      # Add a desktop entry for the Windows VM on NixNuc (only on hosts with the desktop module)
      environment.systemPackages = lib.mkIf config.programs.dwl.enable [
        pkgs.freerdp
        (pkgs.makeDesktopItem {
          name = "windows-rdp";
          desktopName = "Windows (NixNuc)";
          icon = "preferences-desktop-remote-desktop";
          exec = toString (
            pkgs.writeShellScript "windows-rdp" ''
              ${pkgs.freerdp}/bin/sdl-freerdp /v:nixnuc /u:jorink /p:windows /dynamic-resolution
            ''
          );
        })
      ];

      # # Let tailscale traffic bypass the mullvad tunnel/firewall
      systemd.services.mullvad-tailscale = lib.mkIf config.services.mullvad-vpn.enable (
        let
          rules = pkgs.writeText "mullvad-tailscale.nft" ''
            table inet mullvad-tailscale {
              chain outgoing {
                type route hook output priority -100; policy accept;
                meta mark & 0xff0000 == 0x80000 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
                ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
                ip6 daddr fd7a:115c:a1e0::/48 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
              }
              chain incoming {
                type filter hook input priority -100; policy accept;
                iifname "tailscale0" ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
              }
            }
          '';
        in
        {
          description = "Allow tailscale traffic alongside mullvad";
          wantedBy = [ "multi-user.target" ];
          after = [
            "mullvad-daemon.service"
            "tailscaled.service"
          ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStartPre = "-${pkgs.nftables}/bin/nft delete table inet mullvad-tailscale";
            ExecStart = "${pkgs.nftables}/bin/nft -f ${rules}";
            ExecStop = "${pkgs.nftables}/bin/nft delete table inet mullvad-tailscale";
          };
        }
      );
    };
}
