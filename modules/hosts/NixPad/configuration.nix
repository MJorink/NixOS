{ self, inputs, ... }: {
	flake.nixosConfigurations.NixPad = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.hostNixPad
		];
	};
	flake.nixosModules.hostNixPad = { lib, pkgs, ... }: {
		networking.hostName = "NixPad";
		imports = [
			self.nixosModules.base
			self.nixosModules.hostNixPadPackages # packages.nix
			self.nixosModules.terminal # terminal.nix
			self.nixosModules.mango # mango.nix
			self.nixosModules.desktop # desktop.nix
			self.nixosModules.desktopExtras # desktop.nix
			self.nixosModules.video # media.nix
			self.nixosModules.music # media.nix
			# self.nixosModules.school # school.nix
		];
	};
}
