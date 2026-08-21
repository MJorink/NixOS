{ self, inputs, ... }: {
	flake.nixosModules.hostVictusPackages = { pkgs, lib, ... }: {
		environment.systemPackages = with pkgs; [
			# Install host-specific packages here
		];
	};
}
