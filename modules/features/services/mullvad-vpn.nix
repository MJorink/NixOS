{ ... }: {
  flake.nixosModules.mullvad-vpn =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.mullvad-vpn.enable = true;

      systemd.services.mullvad-settings =
        let
          mullvad = "${config.services.mullvad-vpn.package}/bin/mullvad";
        in
        {
          description = "Apply declarative Mullvad VPN settings";
          wantedBy = [ "multi-user.target" ];
          after = [ "mullvad-daemon.service" ];
          requires = [ "mullvad-daemon.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            for _ in $(seq 60); do
              ${mullvad} relay list 2>/dev/null | grep -q . && break
              sleep 1
            done

            ${mullvad} tunnel set daita off
            ${mullvad} relay set location nl
            ${mullvad} relay set ownership owned
            ${mullvad} relay set multihop on
            ${mullvad} relay set entry location nl
            ${mullvad} auto-connect set on
            ${mullvad} lan set allow
            ${mullvad} dns set default
            ${mullvad} tunnel set ipv6 off
            ${mullvad} lockdown-mode set on
            ${mullvad} tunnel set quantum-resistant on
          '';
        };

      systemd.services.mullvad-exclude-jorink = {
        description = "Exclude jorink.nl and the home LAN subnets from the Mullvad tunnel";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.nftables}/bin/nft -f ${pkgs.writeText "mullvad-exclude-jorink.nft" ''
            table inet mullvadExclude {
              chain output {
                type route hook output priority 0; policy accept;
                ip daddr { 185.103.156.20, 85.144.174.244 } ct mark set 0x00000f41 meta mark set 0x6d6f6c65
                ip daddr { 192.168.10.0/24, 192.168.100.0/24 } ct mark set 0x00000f41 meta mark set 0x6d6f6c65
                ip daddr 192.168.100.1 meta l4proto { tcp, udp } th dport 53 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
              }
            }
          ''}";
          ExecStop = "${pkgs.nftables}/bin/nft delete table inet mullvadExclude";
        };
      };

      preservation.preserveAt."/persistent" = {
        directories = [
          "/etc/mullvad-vpn"
          "/var/cache/mullvad-vpn"
        ];
      };
    };
}
