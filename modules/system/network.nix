# iwd does Wi-Fi and DHCP itself: no NetworkManager, dhcpcd or resolved.
{
  flake.modules.nixos.network = { pkgs, ... }: {
    networking = {
      useDHCP = false;
      dhcpcd.enable = false;
      nftables.enable = true;
      firewall.enable = true;
      wireless.iwd = {
        enable = true;
        settings = {
          General.EnableNetworkConfiguration = true;
          Network.NameResolvingService = "resolvconf";
        };
      };
    };
    systemd.services.iwd.path = [ pkgs.openresolv ];

    environment.persistence."/persist".directories = [ "/var/lib/iwd" ]; # known networks
  };
}
