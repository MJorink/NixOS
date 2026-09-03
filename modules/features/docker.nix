{ self, inputs, ... }: {
	flake.nixosModules.docker = { lib, pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			lazydocker
		];
		
		virtualisation.docker = {
			enable = true;
			storageDriver = "btrfs";
			daemon.settings = {
				data-root = "/home/jorink/docker";
			};
		};

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [ "docker" ];
		};
	};
}
