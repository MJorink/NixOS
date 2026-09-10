{ self, inputs, ... }: {
	flake.nixosModules.base	= { lib, pkgs, ... }: {
		programs.direnv = {
			enable = true;
			nix-direnv.enable = true;
		};
	};
}
