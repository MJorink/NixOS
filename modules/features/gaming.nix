{ self, inputs, ... }: {
	flake.nixosModules.FlatGames = { lib, pkgs, ... }: {
		programs.steam.enable = true;
		environment.systemPackages = with pkgs; [
			protonup-qt
		];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".steam"
				".local/share/Steam"
				".local/share/PrismLauncher"
			];
		};
	};

	flake.nixosModules.VRGames = { lib, pkgs, ... }: {
		# Use on top of FlatGames
		services.wivrn = {
			enable = true;
			openFirewall = true;
			autoStart = true;
		};
		
		environment.systemPackages = with pkgs; [
			xrizer
		];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".config/wivrn"
			];
		};
	};
}
