{ self, inputs, ... }: {
	flake.nixosModules.base = {
		imports = [
			inputs.preservation.nixosModules.default
		];

		systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ]; # We manually preserve /etc/machine-id.
		
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
