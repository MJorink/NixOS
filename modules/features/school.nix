{ self, inputs, ... }: {
	flake.nixosModules.school = { lib, pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			
		];
	};
}
