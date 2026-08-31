{ self, inputs, ... }: {
	flake.nixosConfigurations.BaseInstall = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.hostBaseInstall
		];
	};
	flake.nixosModules.hostBaseInstall = { lib, pkgs, ... }: {
		networking.hostName = "BaseInstall";
		imports = [
			self.nixosModules.base
		];
	};
}
