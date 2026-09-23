{ ... }: {
  flake.nixosModules.zed =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        zed-editor
      ];

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".config/zed"
          ".local/share/zed"
        ];
      };
    };
}
