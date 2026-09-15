{ ... }: {
  flake.nixosModules.browser =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        librewolf
        ungoogled-chromium
      ];

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".config/librewolf"
        ];
      };
    };
}
