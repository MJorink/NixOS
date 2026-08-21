{ self, inputs, ... }: {
	flake.nixosModules.FlatGames = { pkgs, lib, ... }: {
		programs.steam.enable = true;
		environment.systemPackages = with pkgs; [
			protonup-qt
		];
	};

	flake.nixosModules.VRGames = { pkgs, lib, ... }: {
		programs.steam.enable = true;
		services.wivrn = {
			enable = true;
			openFirewall = true;
			autoStart = true;
		};
		
		environment.systemPackages = with pkgs; [
			xrizer
		];
	};
}
