{ self, inputs, ... }: {
	perSystem = { lib, pkgs, ... }: {
		packages.myZsh = inputs.wrapper-modules.wrappers.zsh.wrap {
			inherit pkgs;
			runtimePkgs = [
				self.packages.${pkgs.stdenv.hostPlatform.system}.myStarship
				self.packages.${pkgs.stdenv.hostPlatform.system}.myYazi
				self.packages.${pkgs.stdenv.hostPlatform.system}.myGit
				self.packages.${pkgs.stdenv.hostPlatform.system}.myBtop
				pkgs.lazygit
				pkgs.micro
				pkgs.nh
				pkgs.figlet
				pkgs.unzip
				pkgs.zip
				pkgs.wget
			];
			
			zshAliases = {
				clr = "clear";
				ls = "ls -a --color";
				dnb = "clear;dotnet build";
				lg = "lazygit";
				ld = "lazydocker";

				# Scripts
				batstat = "~/NixOS/modules/features/scripts/batstat.sh";
				system-age-info = "~/NixOS/modules/features/scripts/system-age-info.sh file /persistent/passwd";
				dnball = "~/NixOS/modules/features/scripts/build-mods.sh";
			};
			
			zshrc.content = ''
				HISTFILE=~/.local/share/zsh/history
				HISTSIZE=10000
				SAVEHIST=10000
				mkdir -p ~/.local/share/zsh
				setopt APPEND_HISTORY
				setopt SHARE_HISTORY

				source ${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
				eval "$(starship init zsh)"
				source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

				if [[ ! -o login ]]; then
					echo -e "\e[32m$(uname -n | figlet -f slant)\e[0m"
					echo -e "\e[34m$(uname -r)\e[0m";echo ""
				fi
			'';
		};
	};
}
