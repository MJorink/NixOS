{ ... }: {
  flake.nixosModules.tlp = { lib, pkgs, ... }: {
    services.tlp = {
      enable = true;
      settings = {
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 1;
      };
    };
  };
}
