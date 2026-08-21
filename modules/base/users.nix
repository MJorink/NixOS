{ self, inputs, ... }: {
	flake.nixosModules.base = { pkgs, lib, ... }: {
		users.users = {
			jorink = {
				isNormalUser = true;
				# initialPassword = "12345"; # For system setup
				hashedPasswordFile = "/persistent/passwd"; # mkpasswd -m yescrypt > /persistent/passwd
				extraGroups = [ "wheel" "networkmanager" ];
			};
		};
	};
}
