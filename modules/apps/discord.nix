# Discord (unfree, allowed in base.nix). Native Wayland: there is no Xwayland here.
{
  flake.modules.nixos.discord = { pkgs, ... }: {
    environment.systemPackages = [ (pkgs.discord.override { commandLineArgs = "--ozone-platform=wayland"; }) ];
    environment.persistence."/persist".users.jorink.directories = [ ".config/discord" ];
  };
}
