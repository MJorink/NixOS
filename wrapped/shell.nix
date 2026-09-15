{
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    {
      packages.myShell = inputs.wrapper-modules.wrappers.fish.wrap {
        inherit pkgs;
        runtimePkgs = with pkgs; [
          self.packages.${pkgs.stdenv.hostPlatform.system}.myStarship
          self.packages.${pkgs.stdenv.hostPlatform.system}.myYazi
          self.packages.${pkgs.stdenv.hostPlatform.system}.myGit
          self.packages.${pkgs.stdenv.hostPlatform.system}.myBtop
          self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim
          lazygit
          lazydocker
          micro
          nh
          figlet
          unzip
          zip
          wget
        ];

        shellAliases = {
          clr = "clear";
          ls = "ls -a --color";
          dnb = "clear;dotnet build";
          lg = "lazygit";
          ld = "lazydocker";

          # Scripts
          batstat = "~/NixOS/assets/scripts/batstat.sh";
          system-age-info = "~/NixOS/assets/scripts/system-age-info.sh file /persistent/passwd";
          dnball = "~/NixOS/assets/scripts/build-mods.sh";
        };

        configFile.content = ''
          set -g fish_history fish

          starship init fish | source
          direnv hook fish | source

          if status is-interactive; and not status is-login
            set_color green; uname -n | figlet -f slant
            set_color blue; uname -r
            set_color normal; echo
          end
        '';
      };
    };
}
