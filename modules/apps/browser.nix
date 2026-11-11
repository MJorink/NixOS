# LibreWolf with prefs and extension policies from the dotfiles repo, added to
# LibreWolf's own (its uBlock Origin policy stays).
{ inputs, ... }:
{
  flake.modules.nixos.browser = { pkgs, lib, ... }:
    let df = inputs.dotfiles; in
    {
      environment.systemPackages = [
        (pkgs.librewolf.override (old: {
          extraPrefsFiles = (old.extraPrefsFiles or [ ]) ++ [ "${df}/.librewolf/librewolf.overrides.cfg" ];
          extraPolicies = (lib.importJSON "${df}/.librewolf/policies.json").policies;
        }))
      ];
      environment.persistence."/persist".users.jorink.directories = [ ".config/librewolf" ];
    };
}
