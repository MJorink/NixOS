{ self, inputs, ... }: {
	flake.nixosModules.hostVictusPackages = { lib, pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			# Install host-specific packages here
		];
	};
}
