{ ... }: {
  flake.nixosModules.auto-cpufreq =
    {
      lib,
      pkgs,
      ...
    }:
    {
      services.auto-cpufreq = {
        enable = true;
        settings.charger = {
          governor = "performance";
          turbo = "auto";
        };
        settings.battery = {
          governor = "powersave";
          turbo = "never";
        };
      };
    };
}
