{ self, inputs, ... }: {
	flake.nixosModules.base = { lib, pkgs, ... }: {
		imports = [ inputs.preservation.nixosModules.default ];

		# /etc/machine-id is preserved with preservation, so disable service.
		systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
		
		preservation = {
			enable = true;
			preserveAt."/persistent" = {
				directories = [ { directory = "/var/lib/nixos"; inInitrd = true; } ];
				files = [ { file = "/etc/machine-id"; inInitrd = true; } ];
			};
		};		
	};
}
