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

      # Mullvad keeps its settings in /etc/mullvad-vpn/settings.json, so apply them via the CLI on every boot
      # The kill switch is always on in the Mullvad app and has no setting
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
            # Wait for the daemon to accept connections
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

      preservation.preserveAt."/persistent" = {
        directories = [ "/etc/mullvad-vpn" ];
      };
    };
}
