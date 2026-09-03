{ self, inputs, ... }: {
	flake.nixosConfigurations.Victus = inputs.nixpkgs.lib.nixosSystem {
		modules = [ self.nixosModules.hostVictus ];
	};
	
	flake.nixosModules.hostVictus = { lib, pkgs, ... }: {
		networking.hostName = "Victus";
		imports = [
			self.nixosModules.base
			self.nixosModules.home
			self.nixosModules.claude
			self.nixosModules.mango
			self.nixosModules.desktop
			self.nixosModules.desktopExtras
			self.nixosModules.spotify
			self.nixosModules.steam
			self.nixosModules.vr
		];
	};
}
