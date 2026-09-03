{ self, inputs, ... }: {
	flake.nixosModules.bonelab = { lib, pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			android-file-transfer
			ilspycmd
		];
	};
}
