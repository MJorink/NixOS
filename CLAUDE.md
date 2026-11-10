# NixOS config: ThinkPad X270

## Requirements (keep these when changing anything)

- **As light as possible**: CPU, RAM, disk, boot time. Pick the lightest tool that fully
  does the job; no daemons that could be socket/on-demand activated; no default packages,
  docs (only mandoc man pages), portals, polkit, NetworkManager, sudo.
- **Vim keybinds wherever possible** (bemenu, htop, shell `set -o vi`, nvim, Vimium, dwl hjkl).
- **Impermanence**: `/` (and $HOME) is tmpfs. Only paths listed in
  `environment.persistence."/persist"` survive a reboot. Each feature module lists its own
  paths next to the feature. Programs that save files by rename need a persisted
  *directory*, not a persisted file.
- **Dendritic / modular**: every `.nix` under `modules/` is a flake-parts module (import-tree)
  defining `flake.modules.nixos.<feature>`; hosts list the features they use
  (`modules/hosts/thinkpad/default.nix`). One feature per file. Files/dirs starting with
  `_` are ignored by import-tree.
- **One-command install**: `sudo ./install.sh` from the NixOS ISO (after internet + clone).
  Keep it that way.
- **Custom packages/patches** (dwl, slstatus, bemenu, htop, font subset, firmware subset)
  live in github.com/MJorink/packages (`~/repos/packages`), used through its overlay.
  Never put patches or package derivations here.
- **Dotfiles are not written in Nix.** They live in github.com/MJorink/dotfiles
  (`~/repos/dotfiles`, flake input `dotfiles`, `flake = false`) and must keep working on
  non-Nix systems. Here, programs that accept a config path are wrapped with
  `inputs.wrappers.lib.wrapPackage` (github:lassulus/wrappers) to read it from the input;
  the rest are linked into $HOME by `modules/desktop/dotfiles.nix` (tmpfiles).
- Claude Code config (settings.json, CLAUDE.md, rules) is in the dotfiles repo under
  `.claude/`, linked from the writable checkout. Plugins are installed by Claude Code from
  `enabledPlugins`/`extraKnownMarketplaces` in settings.json; their cache persists in ~/.claude.

## Layout

```
flake.nix                    inputs; outputs = import-tree ./modules
install.sh                   ISO installer (disko + password + clone repos + nixos-install)
modules/flake.nix            flake-parts: systems, flake.modules
modules/hosts/thinkpad/      host: feature list + hardware
modules/system/              base (nix, trimming), boot, disk (disko), impermanence, users (doas), network (iwd), ssh, audio, bluetooth
modules/desktop/             desktop (dwl session, wrapped foot/fnott/swaylock, fonts, logind), dotfiles (links)
modules/apps/                browser (LibreWolf), dev (nvim, htop, LSPs, docker, claude-code, `up`)
```

## Workflow

- Apply: `doas nixos-rebuild switch --flake ~/repos/NixOS`. Update everything: `up` (MOD+u).
- Test local changes of the other repos without pushing:
  `--override-input dotfiles ~/repos/dotfiles` / `--override-input packages ~/repos/packages`.
- New files must be `git add`ed before Nix sees them (flakes only read tracked files).
- Check before switching: `nix eval .#nixosConfigurations.thinkpad.config.system.build.toplevel.drvPath`,
  then `nix build` of the same attribute. On a machine without Nix (the old Alpine install), use
  rootless nix-portable: `NP_LOCATION=~/.cache/nix-portable ~/.cache/nix-portable/nix-portable nix ...`
  (keep TMPDIR on /tmp: builds fail with "chmod: Operation not permitted" on the ZFS home).
- Do not commit or push: put the commit message on the clipboard (`wl-copy`) and say so.
- Ask before running anything as root.
