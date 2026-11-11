# Editor, CLI tools, language servers, Docker, Claude Code.
{ inputs, ... }:
{
  flake.modules.nixos.dev = { pkgs, ... }:
    let
      df = inputs.dotfiles;
      wrap = args: inputs.wrappers.lib.wrapPackage ({ inherit pkgs; } // args);
      # MOD+u (dwl config.h): update all inputs and switch. `up -n`: switch without updating.
      # dotfiles/packages come from the local checkouts (unpushed edits included, new files
      # need `git add`); the lock keeps the GitHub revs so install.sh still works.
      # nh builds as the user (root can't open the user-owned repos) and doas-es only to activate.
      up = pkgs.writeShellScriptBin "up" ''
        set -e
        [ "$1" = -n ] || update=-u
        nh os switch $update ~/repos/NixOS -- \
          --override-input dotfiles ~/repos/dotfiles \
          --override-input packages ~/repos/packages
      '';
    in
    {
      environment.systemPackages = with pkgs; [
        (wrap {
          package = neovim;
          flags = {
            "--cmd" = "set rtp^=${df}/.config/nvim"; # colors/caelus.lua
            "-u" = "${df}/.config/nvim/init.lua";
          };
        })
        (wrap { package = htop; env.HTOPRC = "${df}/.config/htop/htoprc"; }) # vim keys (packages repo)
        up
        gitMinimal # no docs/perl/python (send-email, svn, gui unused)
        lazygit
        nnn
        fzf
        ripgrep
        fd
        curl
        lsof
        man-pages
        lua-language-server
        clang-tools # clangd
        csharp-ls
        nil # nix LSP
        nixfmt # nil's formatter
        dotnet-sdk_10
        nodejs # Claude Code plugin hooks (ECC) run on node
        claude-code
      ];

      # `doas nixos-rebuild` reads this user-owned flake as root; Nix's libgit2 refuses it otherwise
      environment.etc.gitconfig.text = ''
        [safe]
        	directory = /home/jorink/repos/NixOS
      '';

      # Started on first use of the docker socket, not at boot
      virtualisation.docker = { enable = true; enableOnBoot = false; };
      users.users.jorink.extraGroups = [ "docker" ];

      environment.persistence."/persist" = {
        directories = [ "/var/lib/docker" ];
        users.jorink.directories = [
          ".claude" # all Claude Code state (CLAUDE_CONFIG_DIR, see dotfiles .profile)
          ".local/share/nvim" # vim.pack plugins
          ".nuget" # NuGet package cache
        ];
      };
    };
}
