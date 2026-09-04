{ self, inputs, ... }: {
	flake.nixosConfigurations.NixPad = inputs.nixpkgs.lib.nixosSystem {
		modules = [ self.nixosModules.hostNixPad ];
	};
	
	flake.nixosModules.hostNixPad = { lib, pkgs, ... }: {
		networking.hostName = "NixPad";
		imports = [
			self.nixosModules.base
			self.nixosModules.home
			self.nixosModules.claude
			self.nixosModules.desktop
			self.nixosModules.desktopExtras
			self.nixosModules.spotify
			self.nixosModules.office
			self.nixosModules.docker
		];
	};
}
