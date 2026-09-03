{ self, inputs, ... }: {
	flake.nixosModules.school = { lib, pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			onlyoffice-desktopeditors
		];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".local/share/onlyoffice"
				".config/onlyoffice"
			];
		};
	};
}
