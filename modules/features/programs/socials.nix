{ ... }: {
  flake.nixosModules.socials =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        discord
      ];

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".config/discord"
        ];
      };
    };
}
