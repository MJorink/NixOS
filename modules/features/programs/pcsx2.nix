{ ... }: {
  flake.nixosModules.pcsx2 =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        pcsx2
      ];

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".config/PCSX2"
        ];
      };
    };
}
