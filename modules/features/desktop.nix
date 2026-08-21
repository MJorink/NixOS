{ self, inputs, ... }: {
	flake.nixosModules.desktop = { pkgs, lib, ... }: {
		# General cross-desktop stuff, import actual desktop module in host module
		services.mullvad-vpn.gui.enable = true;
		services.displayManager.ly.enable = true;
		services.pipewire.enable = true;
		services.pipewire.pulse.enable = true;

		environment.systemPackages = with pkgs; [
			bibata-cursors
		];

		fonts.packages = with pkgs; [
			nerd-fonts.ubuntu
			nerd-fonts.ubuntu-mono
		];		
	};

	flake.nixosModules.desktopExtras = { pkgs, lib, ... }: {
		# Install personal packages here (for all hosts)
		environment.systemPackages = with pkgs; [
			librewolf
			proton-authenticator
			localsend
			filezilla
			qbittorrent
		];
	};
}
