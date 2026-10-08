{ self, inputs, ... }: {
  perSystem = { lib, pkgs, ... }: {
    packages.myShell = inputs.wrapper-modules.wrappers.fish.wrap {
      inherit pkgs;
      runtimePkgs = with pkgs; [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myYazi
        self.packages.${pkgs.stdenv.hostPlatform.system}.myGit
        self.packages.${pkgs.stdenv.hostPlatform.system}.myBtop
        self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim
        self.packages.${pkgs.stdenv.hostPlatform.system}.myNh
        lazygit
        lazydocker
        figlet
        unzip
        zip
        wget
      ];

      shellAliases = {
        clr = "clear";
        ls = "ls -a --color";
        lg = "lazygit";
        ld = "lazydocker";
        yazi = "sudo yazi";

        # Scripts
        batstat = "~/NixOS/assets/scripts/batstat.sh";
        system-age-info = "~/NixOS/assets/scripts/system-age-info.sh file /persistent/passwd";
        dnball = "~/NixOS/assets/scripts/build-mods.sh";
      };

      flags."--no-config" = false;

      configFile.content = ''
        set -g fish_history fish
        set -g fish_greeting

        direnv hook fish | source

        function fish_prompt
          set -l last $status
          echo
          set_color --bold cyan; echo -n (prompt_pwd -D 3)
          if set -l st (command git --no-optional-locks status --porcelain=v2 --branch 2>/dev/null)
            set_color normal; echo -n ' on '
            set_color --bold magenta; echo -n ' '(string replace -rf '^# branch.head ' "" $st)
            set_color --bold red; string match -qv '#*' $st; and echo -n '*'
            if set -l ab (string match -r '^# branch.ab \+(\d+) -(\d+)' $st)
              set_color cyan
              test $ab[2] -gt 0; and echo -n ' ⇡'
              test $ab[3] -gt 0; and echo -n ' ⇣'
            end
          end
          if test $CMD_DURATION -gt 2000
            set_color normal; echo -n ' took '
            set_color --bold yellow; echo -n (math -s1 $CMD_DURATION / 1000)s
          end
          echo
          test $last -eq 0; and set_color --bold green; or set_color --bold red
          echo -n '❯ '
          set_color normal
        end

        if status is-interactive; and not status is-login
          set_color green; uname -n | figlet -f slant
          set_color blue; uname -r
          set_color normal; echo
        end
      '';
    };
  };
}
