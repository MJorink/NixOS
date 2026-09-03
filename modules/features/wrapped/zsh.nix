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
				clr = "clear;~/NixOS/modules/features/scripts/greeting.sh";
				batstat = "~/NixOS/modules/features/scripts/batstat.sh";
				system-age-info = "~/NixOS/modules/features/scripts/system-age-info.sh file /persistent/passwd";
				ls = "ls -a --color";
				yazi = "sudo yazi";
				dnb = "clear;dotnet build";
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
					if [ -e ~/NixOS/modules/features/scripts/greeting.sh ]; then
						~/NixOS/modules/features/scripts/greeting.sh
					fi
				fi
			'';
		};
	};
}
