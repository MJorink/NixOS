{ self, inputs, ... }: {
	flake.nixosModules.steam = { lib, pkgs, ... }: {
		programs.steam.enable = true;
		environment.systemPackages = with pkgs; [ protonup-qt ];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".steam"
				".local/share/Steam"
			];
		};
	};
}
