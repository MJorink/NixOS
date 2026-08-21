{ self, inputs, ... }: {
	flake.nixosModules.music = { pkgs, lib, ... }: {
		environment.systemPackages = with pkgs; [
			ncspot
			spotify
		];
	};

	flake.nixosModules.video = { pkgs, lib, ... }: {
		environment.systemPackages = with pkgs; [
			mpv
		];
	};
}
