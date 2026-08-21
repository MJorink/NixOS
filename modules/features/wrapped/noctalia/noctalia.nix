{ self, inputs, ... }: {
	flake.nixosModules.noctalia = { pkgs, lib, ... }: {
		imports = [
			inputs.noctalia.nixosModules.default
		];

		disabledModules = [ "programs/wayland/noctalia.nix" ]; # Conflicts with flake

		programs.noctalia = {
			enable = true;
			recommendedServices.enable = false;
			package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia;
		};

		nix.settings = {
			extra-substituters = [ "https://noctalia.cachix.org" ];
			extra-trusted-public-keys = [
				"noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
			];
		};
	};

	perSystem = { pkgs, lib, ... }: {
		packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
			inherit pkgs;
			package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
			# settings = builtins.fromTOML (builtins.readFile ./noctalia.toml); # Wrapper module needs updating
		};
	};
}
