{ ... }: {
  flake.nixosModules.security =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        proton-authenticator
      ];

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".local/share/me.proton.authenticator"
        ];
      };
    };
}
