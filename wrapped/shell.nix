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
          nh
          figlet
          unzip
          zip
          wget
          dotnet-sdk_10
          dotnet-runtime_10
        ];

        shellAliases = {
          clr = "clear";
          ls = "ls -a --color";
          dnb = "clear;dotnet build";
          dnr = "clear;dotnet run";
          lg = "lazygit";
          ld = "lazydocker";
          NixPad = "ssh 192.168.100.149";

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
