{ ... }: {
  flake.nixosModules.steam =
    {
      lib,
      pkgs,
      ...
    }:
    {
      programs.steam.enable = true;
      environment.systemPackages = with pkgs; [
        protonup-qt
        mangohud
      ];

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".local/share/Steam"
          ".steam"
          ".local/share/mangohud"
        ];
      };

      environment.variables = {
        MANGOHUD_CONFIGFILE = "/home/jorink/.local/share/mangohud/MangoHud.conf";
      };

      services.udev.extraRules = ''
        SUBSYSTEM=="powercap", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chmod -R a+r /sys/devices/virtual/powercap/intel-rapl"
      '';

      boot.kernel.sysctl = {
        "vm.max_map_count" = 2147483642;
      };
    };
}
