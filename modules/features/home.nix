{ self, inputs, ... }: {
	flake.nixosModules.home = { lib, pkgs, ... }: {
		# Manage dotfiles for packages that are not available in nix-wrapper-modules.
		imports = [ inputs.home-manager.nixosModules.home-manager ];

		home-manager = {
			useGlobalPkgs = false;
			useUserPackages = false;
			backupFileExtension = "backup";

			users.jorink = { config, ... }:
			let
				dotfiles = "${config.home.homeDirectory}/NixOS/modules/features/configs";
				create_symlink = config.lib.file.mkOutOfStoreSymlink;

				configs = {
					micro = "micro";
				};
			in {
				home = {
					username = "jorink";
					homeDirectory = "/home/jorink";
					stateVersion = "26.05";
				};

				xdg.configFile = builtins.mapAttrs (name: subpath: {
					source = create_symlink "${dotfiles}/${subpath}";
					recursive = true;
				}) configs;
			};
		};
	};
}
