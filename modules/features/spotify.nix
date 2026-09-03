{ self, inputs, ... }: {
	flake.nixosModules.spotify = { lib, pkgs, ... }: {
		environment.systemPackages = with pkgs; [ spotify ];
		
		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".config/spotify"
				".cache/spotify"
			];
		};
	};
}
