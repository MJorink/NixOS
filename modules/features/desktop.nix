{ self, inputs, ... }: {
	flake.nixosModules.desktop = { lib, pkgs, ... }: {
		# General cross-desktop stuff
		services.mullvad-vpn.gui.enable = true;
		services.displayManager.ly.enable = true;
		services.pipewire.enable = true;
		services.pipewire.pulse.enable = true;

		environment.systemPackages = with pkgs; [ bibata-cursors ];

		fonts.packages = with pkgs; [
			nerd-fonts.ubuntu
			nerd-fonts.ubuntu-mono
		];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".local/state/wireplumber"
				".local/share/keyrings"
				"Downloads"
				"Documents"
			];
		};
	};

	flake.nixosModules.desktopExtras = { lib, pkgs, ... }: {
		# Install personal packages here (for all hosts)
		environment.systemPackages = with pkgs; [
			librewolf
			proton-authenticator
			mpv
		];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".config/librewolf"
				".local/share/me.proton.authenticator"
			];
		};
	};
}
