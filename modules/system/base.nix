# Nix settings and everything trimmed for a small, fast system.
{ inputs, ... }:
{
  flake.modules.nixos.base = { lib, ... }: {
    nixpkgs.overlays = [ inputs.packages.overlays.default ];
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];

    nix = {
      channel.enable = false;
      registry.nixpkgs.flake = inputs.nixpkgs;
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
      };
      gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 14d"; };
    };
    # / is tmpfs (RAM): build on disk instead
    systemd.services.nix-daemon.environment.TMPDIR = "/nix/tmp";
    systemd.tmpfiles.rules = [ "d /nix/tmp 0755 root root 1d" ];

    # Less on disk and in the closure
    documentation = {
      doc.enable = false;
      info.enable = false;
      nixos.enable = false;
      man.man-db.enable = false;
      man.mandoc.enable = true;
    };
    environment.defaultPackages = [ ];
    programs.nano.enable = false;
    programs.command-not-found.enable = false;
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
    time.timeZone = "Europe/Amsterdam";

    # Perlless activation: /etc as an overlay, users created by userborn.
    # Faster boot/switch (perl itself stays: wl-clipboard -> xdg-utils).
    system.etc.overlay.enable = true;
    services.userborn.enable = true;
    system.tools.nixos-generate-config.enable = false; # perl; hardware is in hosts/

    # Logs in RAM only: no disk writes; lost at reboot like the rest of /
    services.journald.settings.Journal.Storage = "volatile";
    services.journald.settings.Journal.RuntimeMaxUse = "32M";

    zramSwap = { enable = true; memoryPercent = 25; algorithm = "zstd"; };
  };
}
