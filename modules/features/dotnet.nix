{ self, inputs, ... }: {
	flake.nixosModules.dotnet = { lib, pkgs, ... }: {
		environment.systemPackages = with pkgs; [ dotnet-sdk_10 ];
		environment.variables.DOTNET_ROOT = "${pkgs.dotnet-sdk_10}/share/dotnet";
	};
}
