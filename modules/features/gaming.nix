{ self, inputs, ... }: {
	flake.nixosModules.FlatGames = { pkgs, lib, ... }: {
		programs.steam.enable = true;
		environment.systemPackages = with pkgs; [
			protonup-qt
		];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".steam"
				".local/share/Steam"
			];
		};
	};

	flake.nixosModules.VRGames = { pkgs, lib, ... }: {
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
