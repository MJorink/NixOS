{ ... }: {
  flake.nixosModules.auto-upgrade =
    {
      lib,
      pkgs,
      ...
    }:
    {
      system.autoUpgrade = {
        enable = true;
        operation = "boot";
        flake = "/home/jorink/NixOS";
        upgrade = false;
        dates = "daily";
        persistent = true;
        randomizedDelaySec = "10min";
      };

      systemd.services.nixos-upgrade = {
        serviceConfig = {
          ExecStartPre =
            "${pkgs.util-linux}/bin/runuser -u jorink -- "
            + "${pkgs.gitMinimal}/bin/git -C /home/jorink/NixOS pull --ff-only";
          Restart = "on-failure";
          RestartSec = "1min";
        };
        unitConfig = {
          StartLimitBurst = 3;
          StartLimitIntervalSec = "1h";
        };
        onFailure = [ "nixos-upgrade-notify.service" ];
      };

      systemd.services.nixos-upgrade-notify = {
        description = "Desktop notification for a failed NixOS auto-upgrade";
        serviceConfig = {
          Type = "oneshot";
          User = "jorink";
        };
        environment.DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
        script = ''
          ${pkgs.libnotify}/bin/notify-send -u critical \
            "NixOS auto-upgrade failed" "journalctl -u nixos-upgrade -e"
        '';
      };
    };
}
