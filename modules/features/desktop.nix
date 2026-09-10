{ self, inputs, ... }: {
	flake.nixosModules.desktop = { lib, pkgs, ... }: {
		imports = [
			inputs.mangowm.nixosModules.mango
			inputs.noctalia.nixosModules.default
		];
		disabledModules = [ "programs/wayland/noctalia.nix" ]; # Conflicts with flake
		
		services.mullvad-vpn.gui.enable = true;
		services.displayManager.ly.enable = true;
		services.pipewire.enable = true;
		services.pipewire.pulse.enable = true;
		services.upower.enable = true;
		services.gnome.gnome-keyring.enable = true;

		programs.mango = {
			enable = true;
			package = self.packages.${pkgs.stdenv.hostPlatform.system}.myMango;
		};
		systemd.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.myMango ]; # For hot-reloading

		xdg.portal = {
			enable = true;
			wlr.enable = true;
			wlr.settings.screencast.chooser_type = "none";
			extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
			config.common.defualt = "*";
		};

		programs.noctalia = {
			enable = true;
			recommendedServices.enable = false;
			# package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia;
			# Wrapper module is not updated for v5. We use home-manager for now. (home.nix)
		};

		nix.settings = {
			extra-substituters = [ "https://noctalia.cachix.org" ];
			extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
		};
		
		environment.systemPackages = with pkgs; [
			bibata-cursors
		];

		fonts.packages = with pkgs; [
			nerd-fonts.ubuntu
			nerd-fonts.ubuntu-mono
		];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".local/state/wireplumber"
				".local/state/noctalia"
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
			obs-studio
			discord
			zed-editor
		];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".config/librewolf"
				".config/discord"
				".config/obs-studio"
				".local/share/me.proton.authenticator"
			];
		};
	};
}
