{ self, inputs, ... }: {
	flake.nixosModules.home = { lib, pkgs, ... }: {
		# Manage dotfiles for packages that are not available in nix-wrapper-modules.
		imports = [
			home-manager.nixosModules.home-manager
		];

		home-manager = {
			useGlobalPkgs = false;
			useUserPackages = false;
			backupFileExtension = "backup";
		};

		home = {
			username = "jorink";
			homeDirectory = "/home/jorink";
		};

		let
			dotfiles = "${config.home.homeDirectory}/NixOS/modules/features/configs";
			create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

			configs = {
				micro = "micro";
			};
		in

		xdg.configFile = builtins.mapAttrs (name: subpath: {
			source = create_symlink "${dotfiles}/${subpath}";
			recursive = true;
		})
		configs;
	};
}
