{ self, inputs, ... }: {
	flake.nixosModules.hostNixPadPackages = { lib, pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			# Install host-specific packages here
		];
	};
}
