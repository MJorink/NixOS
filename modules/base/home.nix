{ self, inputs, ... }: {
	flake.nixosModules.home = { lib, pkgs, ... }: {
		imports = [
			home-manager.nixosModules.home-manager
		];

		home-manager = {
			useGlobalPkgs = false;
			useUserPackages = false;
			backupFileExtension = "backup";
		};

		home.username = "jorink";
		

		let
			dotfiles = "${config.home.homeDirectory}/NixOS/config";
			create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

			configs = {
				
			};
		in
	};
}
