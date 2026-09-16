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

        constructFiles.config = {
          relPath = "etc/noctalia/config.toml";
          content = builtins.readFile ../assets/noctalia.toml;
        };
      };
    };
}
