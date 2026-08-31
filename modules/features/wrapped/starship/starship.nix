{ self, inputs, ... }: {
	perSystem = { lib, pkgs, ... }: {
		packages.myStarship = inputs.wrapper-modules.wrappers.starship.wrap {
			inherit pkgs;
			settings = builtins.fromTOML (builtins.readFile ./starship.toml);
		};
	};
}
