{ self, inputs, ... }: {
	flake.nixosModules.vr = { lib, pkgs, ... }: {
		services.wivrn = {
			enable = true;
			openFirewall = true;
			autoStart = true;
		};

		environment.systemPackages = with pkgs; [ xrizer ];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [ ".config/wivrn" ];
		};
	};
}
