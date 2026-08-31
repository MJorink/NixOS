{ self, inputs, ... }: {
	flake.nixosModules.music = { lib, pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			spotify
		];
		
		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".config/spotify"
				".cache/spotify"
			];
		};
	};

	flake.nixosModules.video = { lib, pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			mpv
		];
	};
}
