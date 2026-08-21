{ self, inputs, ... }: {
	perSystem = { pkgs, lib, ... }: {
		packages.myStarship = inputs.wrapper-modules.wrappers.starship.wrap {
			inherit pkgs;
			settings = builtins.fromTOML (builtins.readFile ./starship.toml);
		};
	};
}
