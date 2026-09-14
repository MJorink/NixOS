{...}: {
  flake.nixosModules.mullvad-vpn = {
    lib,
    pkgs,
    ...
  }: {
    services.mullvad-vpn.enable = true;

    preservation.preserveAt."/persistent" = {
      directories = ["/etc/mullvad-vpn"];
      users.jorink.directories = [".config/Mullvad VPN"];
    };
  };
}
