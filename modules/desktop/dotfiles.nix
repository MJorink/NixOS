# Dotfiles that cannot be passed as a flag are linked into the (tmpfs) home at boot
# and on every switch. Read-only links go to the dotfiles flake input; Claude Code's
# files link to the writable checkout ~/repos/dotfiles because Claude edits them.
{ inputs, ... }:
{
  flake.modules.nixos.dotfiles =
    let
      home = "/home/jorink";
      fromStore = [
        ".profile"
        ".ashrc"
        ".bashrc"
        ".local/bin"
        ".config/dwl"
        ".config/git"
        ".config/mimeapps.list"
      ];
      fromCheckout = [ ".claude/settings.json" ".claude/CLAUDE.md" ".claude/rules" ];
      # tmpfiles would create missing parents as root; make them the user's first
      dirs = [ ".config" ".local" ".claude" ];
    in
    {
      systemd.tmpfiles.rules =
        map (d: "d ${home}/${d} 0755 jorink users -") dirs
        ++ map (p: "L+ ${home}/${p} - - - - ${inputs.dotfiles}/${p}") fromStore
        ++ map (p: "L+ ${home}/${p} - - - - ${home}/repos/dotfiles/${p}") fromCheckout;
    };
}
