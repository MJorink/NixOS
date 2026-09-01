{ self, inputs, ... }: {
	flake.nixosModules.base = { lib, pkgs, ... }: {
		users = {
			users.jorink = {
				isNormalUser = true;
				hashedPasswordFile = "/persistent/passwd"; # mkpasswd -m yescrypt > /persistent/passwd
				extraGroups = [ "wheel" "networkmanager" ];
			};
		};
		
		preservation.preserveAt."/persistent" = {
			users.jorink = {
				home = "/home/jorink";
				directories = [
					"NixOS"
					"repos"
					".local/share/zsh"
				];
			};
		};
	};
}
