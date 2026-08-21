{ self, inputs, ... }: {
	flake.nixosModules.hostNixPadPackages = { pkgs, lib, ... }: {
		environment.systemPackages = with pkgs; [
			# Install host-specific packages here
		];
	};
}
