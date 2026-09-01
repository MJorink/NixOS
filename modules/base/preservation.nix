{ self, inputs, ... }: {
	flake.nixosModules.base = { lib, pkgs, ... }: {
		imports = [
			inputs.preservation.nixosModules.default
		];

		systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ]; # /etc/machine-id is preserved with preservation
		
		preservation = {
			enable = true;
			preserveAt."/persistent" = {
				directories = [
					{ directory = "/var/lib/nixos"; inInitrd = true; }
				];
				files = [
					{ file = "/etc/machine-id"; inInitrd = true; }
				];
			};
		};		
	};
}
