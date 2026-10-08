{ ... }: {
  flake.nixosModules.browser = { lib, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      ungoogled-chromium
    ];

    # Route the browser through Mullvad's SOCKS5 proxy (only reachable while connected over WireGuard)
    programs.chromium = {
      enable = true;
      extraOpts.ProxySettings = {
        ProxyMode = "fixed_servers";
        ProxyServer = "socks5://10.64.0.1:1080";
        # The LAN and NixNuc's VLAN (e.g. Navidrome/Lidarr) aren't reachable through Mullvad's proxy
        ProxyBypassList = "<local>;192.168.100.0/24;192.168.10.0/24";
      };
    };

    preservation.preserveAt."/persistent" = {
      users.jorink.directories = [
        ".config/chromium"
      ];
    };
  };
}
