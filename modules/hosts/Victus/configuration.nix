{ self, inputs, ... }: {
	flake.nixosConfigurations.Victus = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.hostVictus
		];
	};
	flake.nixosModules.hostVictus = { lib, pkgs, ... }: {
		networking.hostName = "Victus";
		imports = [
			self.nixosModules.base
			self.nixosModules.home # home.nix
			self.nixosModules.terminal # terminal.nix
			self.nixosModules.mango # mango.nix
			self.nixosModules.desktop # desktop.nix
			self.nixosModules.desktopExtras # desktop.nix
			self.nixosModules.video # media.nix
			self.nixosModules.music # media.nix
<<<<<<< HEAD
			self.nixosModules.dotnet # bonelab.nix
=======
>>>>>>> a26d97b (Update Configs)
			self.nixosModules.steam # gaming.nix
			self.nixosModules.vr # gaming.nix
		];
	};
}
