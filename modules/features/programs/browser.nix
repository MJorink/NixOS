{ ... }: {
  flake.nixosModules.browser =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        ungoogled-chromium
      ];

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".config/chromium"
        ];
      };
    };
}
