{ self, inputs, ... }: {
	flake.nixosModules.base = { lib, pkgs, ... }: {
		environment.variables = {
			EDITOR = "micro";
			NH_FLAKE = "/home/jorink/NixOS";
		};
	};
}
