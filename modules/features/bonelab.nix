{ self, inputs, ... }: {
	flake.nixosModules.bonelab = { lib, pkgs, ... }: {
		# BoneLab code modding
		environment.systemPackages = with pkgs; [
			dotnet-sdk
			android-file-transfer
			ilspycmd
		];
	};
}
