{...}: {
  flake.nixosModules.browser = {
    lib,
    pkgs,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      librewolf
    ];

    preservation.preserveAt."/persistent" = {
      users.jorink.directories = [
        ".config/librewolf"
      ];
    };
  };
}
