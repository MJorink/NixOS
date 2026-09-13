{...}: {
  flake.nixosModules.minecraft = {
    lib,
    pkgs,
    ...
  }: {
    environment.systemPackages = with pkgs; [prismlauncher];

    preservation.preserveAt."/persistent" = {
      users.jorink.directories = [
        ".local/share/PrismLauncher"
      ];
    };
  };
}
