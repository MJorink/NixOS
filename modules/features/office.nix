{ self, inputs, ... }: {
	flake.nixosModules.office = { lib, pkgs, ... }: {
		environment.systemPackages = with pkgs; [ onlyoffice-desktopeditors ];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".local/share/onlyoffice"
				".config/onlyoffice"
			];
		};
	};
}
