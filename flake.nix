{
	inputs = {
		# Base
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		flake-parts.url = "github:hercules-ci/flake-parts";
		import-tree.url = "github:vic/import-tree";
		wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
		preservation.url = "github:nix-community/preservation";
		disko.url = "github:nix-community/disko";
		home-manager.url = "github:nix-community/home-manager/release-unstable";
		# Desktop
		mangowm.url = "github:mangowm/mango";
		noctalia.url = "github:noctalia-dev/noctalia/cachix";
	};
	outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} {
		imports = [./parts.nix (inputs.import-tree ./modules)];
	};
}
