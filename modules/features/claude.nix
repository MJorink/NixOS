{ self, inputs, ... }: {
	flake.nixosModules.claude = { lib, pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			claude-code
			nodejs-slim
		];
		
		preservation.preserveAt."/persistent" = {
			users.jorink = {
				directories = [ ".claude" ];
				files = [ ".claude.json" ];
			};
		};
	};
}
