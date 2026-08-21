{ self, inputs, ... }: {
	flake.nixosModules.music = { pkgs, lib, ... }: {
		environment.systemPackages = with pkgs; [
			spotify
		];
		
		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".config/spotify"
			];
		};
	};

	flake.nixosModules.video = { pkgs, lib, ... }: {
		environment.systemPackages = with pkgs; [
			mpv
		];
	};
}
