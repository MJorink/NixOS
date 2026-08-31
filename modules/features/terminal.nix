{ self, inputs, ... }: {
	flake.nixosModules.terminal = { lib, pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			unzip
			zip
			p7zip
			wget
			fastfetch
			claude-code
			nodejs-slim
		];
		
		environment.variables = {
			EDITOR = "micro";
			NH_FLAKE = "/home/jorink/NixOS";
		};

		preservation.preserveAt."/persistent" = {
			users.jorink = {
				directories = [
					".claude"
				];
				files = [
					".claude.json"
				];
			};
		};
	};
}
