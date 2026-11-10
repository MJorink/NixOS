# BlueZ, powered off until used (bluetui from the system menu).
{
  flake.modules.nixos.bluetooth = { pkgs, ... }: {
    hardware.bluetooth = { enable = true; powerOnBoot = false; };
    environment.systemPackages = [ pkgs.bluetui ];
    environment.persistence."/persist".directories = [ "/var/lib/bluetooth" ]; # pairings
  };
}
