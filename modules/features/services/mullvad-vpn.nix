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
            for _ in $(seq 30); do
              ${mullvad} status >/dev/null 2>&1 && break
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

      # Route 192.168.10.0/24 via the LAN gateway, otherwise Mullvad's routing table sends it into the tunnel
      networking.networkmanager.dispatcherScripts = [
        {
          type = "basic";
          source = pkgs.writeShellScript "mullvad-lan-route" ''
            [ "$2" = "up" ] || exit 0
            case "$IP4_ADDRESS_0" in
              192.168.100.*) ${pkgs.iproute2}/bin/ip route replace 192.168.10.0/24 via "$IP4_GATEWAY" dev "$DEVICE_IFACE" ;;
            esac
          '';
        }
      ];

      preservation.preserveAt."/persistent" = {
        directories = [ "/etc/mullvad-vpn" ];
      };
    };
}
