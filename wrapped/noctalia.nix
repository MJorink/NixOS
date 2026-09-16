{ inputs, ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    {
      packages.myNoctalia = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.noctalia;

        env.NOCTALIA_CONFIG_HOME = "${placeholder "out"}/etc";

        runShell = [ "mkdir -p \"$HOME/.local/state/noctalia\" && touch \"$HOME/.local/state/noctalia/.setup-complete\"" ];

        constructFiles.config = {
          relPath = "etc/noctalia/config.toml";
          content = builtins.readFile ../assets/noctalia.toml;
        };
      };
    };
}
