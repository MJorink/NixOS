{ self, inputs, ... }: {
	flake.nixosModules.base = { pkgs, ... }: {
		security.sudo.wheelNeedsPassword = false;
		users.defaultUserShell = self.packages.${pkgs.stdenv.hostPlatform.system}.myZsh;
		environment.shells = [ "${self.packages.${pkgs.stdenv.hostPlatform.system}.myZsh}/bin/zsh" ];
		
		time.timeZone = "Europe/Amsterdam";
		networking.networkmanager.enable = true;
		
		boot.kernelPackages = pkgs.linuxPackages_latest;
		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

		nixpkgs.config.allowUnfree = true;
		nix.settings.experimental-features = [ "nix-command" "flakes" ];
		system.stateVersion = "26.05";
	};
}
